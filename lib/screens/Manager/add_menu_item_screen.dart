import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pollos_hermanos/screens/Client/variations_screen.dart';
import 'package:los_pollos_hermanos/shared/Dropdown.dart';
import 'package:los_pollos_hermanos/shared/GreyTextField.dart';
import 'package:los_pollos_hermanos/shared/ImageUploader.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class AddMenuItemScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Optional data to pre-fill fields

  const AddMenuItemScreen({Key? key, this.initialData}) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    // Populate fields if initialData is provided
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _titleController.text = data['title'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _basePriceController.text = data['basePrice']?.toString() ?? '';
      _discountController.text = data['discount']?.toString() ?? '';
      _category = data['category'];

      // Handle variants
      if (data['variants'] != null && (data['variants'] as List).isNotEmpty) {
        for (var variant in data['variants']) {
          _variantControllers.add(TextEditingController(text: variant));
        }
      } else {
        // Ensure at least one empty controller
        _variantControllers.add(TextEditingController());
      }

      // Handle extras
      if (data['extras'] != null && (data['extras'] as Map).isNotEmpty) {
        data['extras'].forEach((key, value) {
          _extrasControllers.add(TextEditingController(text: key));
          _extrasPriceControllers
              .add(TextEditingController(text: value.toString()));
        });
      } else {
        // Ensure at least one empty controller for extras
        _extrasControllers.add(TextEditingController());
        _extrasPriceControllers.add(TextEditingController());
      }

      // Ignore remote image URLs
      if (data['image'] != null && !data['image'].startsWith('http')) {
        _selectedImage = File(data['image']); // Set only local image paths
      }
    } else {
      // Default initialization when no initialData is provided
      _variantControllers.add(TextEditingController());
      _extrasControllers.add(TextEditingController());
      _extrasPriceControllers.add(TextEditingController());
    }
  }

  void _onSavePressed() {
    List<String> controllersToList(List<TextEditingController> controllers) {
      return controllers.map((controller) => controller.text).toList();
    }

    Map<String, dynamic> formValues = {
      'title': _titleController.text,
      'category': _category,
      'description': _descriptionController.text,
      'image': _selectedImage?.path, // Save the file path of the image
      'variants': controllersToList(_variantControllers),
      'extras': controllersToList(_extrasControllers),
      'extrasPrices': controllersToList(_extrasPriceControllers),
      'basePrice': double.tryParse(_basePriceController.text) ?? 0.0,
      'discount': double.tryParse(_discountController.text) ?? 0.0,
    };

    print(formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: AppBar(
              title: const Text(
                'Add Item',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 26.0,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: Container(
                  color: Styles.inputFieldBorderColor,
                  height: 1.0,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2C230),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  const SizedBox(width: 10),
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
