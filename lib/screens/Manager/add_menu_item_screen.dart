import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';
import 'package:los_pollos_hermanos/screens/Client/category_dropdown.dart';
import 'package:los_pollos_hermanos/screens/Client/variations_screen.dart';
import 'package:los_pollos_hermanos/shared/Dropdown.dart';
import 'package:los_pollos_hermanos/shared/GreyTextField.dart';
import 'package:los_pollos_hermanos/shared/ImageUploader.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class AddMenuItemScreen extends StatefulWidget {
  /// The ID of the Restaurant we want to add items to.
  final String restaurantId;

  AddMenuItemScreen({required this.restaurantId});

  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  // Text controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final List<TextEditingController> _variantControllers = [];
  final List<TextEditingController> _extrasControllers = [];
  final List<TextEditingController> _extrasPriceControllers = [];

  String? _category;
  File? _selectedImage;

  final List<String> _categories = const [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
    'Option 6',
    'Option 7'
  ];

  double pad = 24.0;

  /// Handles saving the new MenuItem to Firestore.
  void _onSavePressed() async {
    try {
      // 1. Validate user input
      if (_category == null || _category!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a category.')),
        );
        return;
      }
      if (_titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Title cannot be empty.')),
        );
        return;
      }

      // 2. Parse numeric fields
      double basePrice = double.tryParse(_basePriceController.text) ?? 0.0;
      double discount = double.tryParse(_discountController.text) ?? 0.0;

      // 3. Build variants list
      List<String> variants = _variantControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      // 4. Build extras map (extraName -> extraPrice)
      Map<String, double> extras = {};
      for (int i = 0; i < _extrasControllers.length; i++) {
        final extraName = _extrasControllers[i].text.trim();
        final extraPrice =
            double.tryParse(_extrasPriceControllers[i].text.trim()) ?? 0.0;
        if (extraName.isNotEmpty) {
          extras[extraName] = extraPrice;
        }
      }

      // 5. Create a MenuItem model with placeholder ID (Firestore will assign one)
      MenuItem newItem = MenuItem(
        id: '', // will be assigned by Firestore
        name: _titleController.text.trim(),
        price: basePrice,
        description: _descriptionController.text.trim(),
        variants: variants,
        extras: extras,
        discount: discount,
        reviewIds: [], // starting empty
        imageUrl: '', // to be replaced if we upload an image
      );

      ManagerServices _managerServices = ManagerServices();
      MenuItem createdItem = await _managerServices.createMenuItemForRestaurant(
        restaurantId: widget.restaurantId,
        category: _category!,
        menuItem: newItem,
        imageFile: _selectedImage, // pass your selected File (if any)
      );

      // 8. Show success and optionally navigate away
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Created item: ${createdItem.name}')),
      );

      Navigator.pop(context, createdItem); // or any other navigation
    } catch (e) {
      // Handle exceptions from services
      print('Error creating menu item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(kToolbarHeight), // Add height for padding
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: pad), // Padding for the app bar
            child: AppBar(
              title: const Text(
                'Add Item',
                style: TextStyle(
                  fontWeight: FontWeight.w900, // Semibold font weight
                  fontSize: 26.0,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: Container(
                  color: Styles.inputFieldBorderColor, // Border color
                  height: 1.0, // Border height
                ),
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.only(left: pad, right: pad, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT DETAILS
              const Text('Product details', style: Styles.smallHeaderTextStyle),
              const SizedBox(height: 8),

              // Title
              GreyTextField(label: 'Title', controller: _titleController),
              const SizedBox(height: 16),

              // Category
              Dropdown(
                selectedValue: _category,
                options: _categories,
                onChange: (value) {
                  setState(() {
                    _category = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Description
              GreyTextField(
                label: 'Description',
                controller: _descriptionController,
                minHeight: 120,
                maxHeight: 120,
              ),
              const SizedBox(height: 24),

              // MEDIA
              const Text('Media',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),

              // Image Upload
              ImageUploader(
                  selectedImage: _selectedImage,
                  onPickImage: () async {
                    final returnedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (returnedImage == null) return;
                    setState(() {
                      _selectedImage = File(returnedImage.path);
                    });
                  }),

              const SizedBox(height: 24),

              // VARIATIONS
              // (from your custom widget `ItemCustomization`)
              ItemCustomization(
                variantControllers: _variantControllers,
                isExtrasSection: false,
              ),
              const SizedBox(height: 24),

              // EXTRAS
              ItemCustomization(
                variantControllers: _extrasControllers,
                priceControllers: _extrasPriceControllers,
                isExtrasSection: true,
              ),
              const SizedBox(height: 24),

              // PRICING
              const Text('Pricing',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: GreyTextField(
                      label: 'Base Price',
                      controller: _basePriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GreyTextField(
                      label: 'Discount (%)',
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Save Button
                  ElevatedButton(
                    onPressed: _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2C230),
                      elevation: 0, // Removes shadow
                      shadowColor: Colors.transparent, // Ensures no shadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),

                  const SizedBox(width: 10),
                  // Discard Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Discard',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
