import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';
import 'package:los_pollos_hermanos/screens/Client/category_dropdown.dart';
import 'package:los_pollos_hermanos/shared/Dropdown.dart';
import 'package:los_pollos_hermanos/shared/GreyTextField.dart';
import 'package:los_pollos_hermanos/shared/ImageUploader.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class EditMenuItemScreen extends StatefulWidget {
  final String restaurantId;
  final String menuItemId;

  EditMenuItemScreen({
    required this.restaurantId,
    required this.menuItemId,
  });

  @override
  _EditMenuItemScreenState createState() => _EditMenuItemScreenState();
}

class _EditMenuItemScreenState extends State<EditMenuItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  MenuItem? menuItem;

  File? _selectedImage;

  double pad = 24.0;

  @override
  void initState() {
    super.initState();
    _fetchMenuItemDetails();
  }

  void _fetchMenuItemDetails() async {
    try {
      ClientService _client_service = ClientService();
      menuItem = await _client_service.getMenuItem(widget.menuItemId);

      if (menuItem != null) {
        setState(() {
          _titleController.text = menuItem!.name;
          _descriptionController.text = menuItem!.description;
          _basePriceController.text = menuItem!.price.toString();
          _discountController.text = menuItem!.discount.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Menu item not found')),
        );
      }
    } catch (e) {
      print('Error fetching menu item details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching menu item details: $e')),
      );
    }
  }

  void _onSavePressed() async {
    try {
      if (_titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Title cannot be empty.')),
        );
        return;
      }

      double basePrice = double.tryParse(_basePriceController.text) ?? 0.0;
      double discount = double.tryParse(_discountController.text) ?? 0.0;

      MenuItem newItem = MenuItem(
        id: '', // will be assigned by Firestore
        name: _titleController.text.trim(),
        price: basePrice,
        description: _descriptionController.text.trim(),
        variants: menuItem!.variants, // No variants section
        extras: menuItem!.extras, // No extras section
        discount: discount,
        reviewIds: [], // starting empty
        imageUrl: '', // to be replaced if we upload an image
      );

      ManagerServices _managerServices = ManagerServices();

      await _managerServices.updateMenuItem(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Edit successful')),
      );

      Navigator.pop(context);
    } catch (e) {
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
                'Edit Item',
                style: TextStyle(
                  fontWeight: FontWeight.w900, // Semibold font weight
                  fontSize: 26.0,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
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
              const Text('Product details', style: Styles.smallHeaderTextStyle),
              const SizedBox(height: 8),
              GreyTextField(label: 'Title', controller: _titleController),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2C230),
                      elevation: 0, // Removes shadow
                      shadowColor: Colors.transparent, // Ensures no shadow
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
