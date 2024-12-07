import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pollos_hermanos/screens/Client/category_dropdown.dart';
import 'package:los_pollos_hermanos/screens/Client/variations_screen.dart';
import 'package:los_pollos_hermanos/shared/Dropdown.dart';
import 'package:los_pollos_hermanos/shared/GreyTextField.dart';
import 'package:los_pollos_hermanos/shared/ImageUploader.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class AddMenuItemScreen extends StatefulWidget {
  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  // Text controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final List<TextEditingController> _variantControllers =
      []; // Controllers for input fields

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

  void _onSavePressed() {
    List<String> controllersToList(List<TextEditingController> controllers) {
      return controllers.map((controller) => controller.text).toList();
    }

    Map<String, dynamic> formValues = {
      'title': _titleController.text,
      'category': _category,
      'description': _descriptionController.text,
      'image': _selectedImage,
      'variants': controllersToList(_variantControllers),
      'extras': controllersToList(_extrasControllers),
      'extrasPrices': controllersToList(_extrasPriceControllers),
      'basePrice': _basePriceController.text,
      'discount': _discountController.text,
    };

    print(formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white, // Set the background color explicitly
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
                preferredSize: const Size.fromHeight(
                    10.0), // Adjusted for padding and border height
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
                  maxHeight: 120),
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
              // Base Price
              const Text('Pricing',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),

              const SizedBox(height: 8),

              // Discount
              Row(
                children: [
                  Expanded(
                      child: GreyTextField(
                          label: 'Base Price',
                          controller: _basePriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: GreyTextField(
                          label: 'Discount (%)',
                          controller: _discountController,
                          keyboardType: TextInputType.number)),
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

                  const SizedBox(width: 10), // Spacing between buttons
                  // Discard Button
                  ElevatedButton(
                    onPressed: () {},
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
              const SizedBox(
                height: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
