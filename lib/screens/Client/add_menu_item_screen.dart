import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pollos_hermanos/screens/Client/category_dropdown.dart';
import 'package:los_pollos_hermanos/screens/Client/variations_screen.dart';

class AddMenuItemScreen extends StatefulWidget {
  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  // Horizontal page padding
  final double pad = 24.0;

  // Text controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final List<TextEditingController> _variantControllers =
      []; // Controllers for input fields

  final List<TextEditingController> _extrasControllers = [];
  final List<TextEditingController> _extrasPriceControllers = [];

  String? _category;
  File? _selectedImage;

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Shadow shadow = Shadow(
      color: Colors.black.withOpacity(1),
      blurRadius: 12,
      offset: Offset(0, 0),
    );
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
                  color:
                      const Color.fromRGBO(217, 217, 217, 0.6), // Border color
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
              const Text('Product details',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              GreyTextField(label: 'Title', controller: _titleController),
              const SizedBox(height: 16),
              // GreyTextField(label: 'Category', controller: _categoryController),

              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(50, 50, 50, 1),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: const [
                    'Option 1',
                    'Option 2',
                    'Option 3',
                    'Option 4',
                    'Option 5',
                    'Option 6',
                    'Option 7'
                  ]
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(50, 50, 50, 1),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: _category,
                  onChanged: (String? value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    // width: 160,
                    padding: const EdgeInsets.only(left: 0, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      // border: Border.all(
                      // color: Colors.grey[400]!,
                      // ),
                      color: Color.fromRGBO(244, 244, 244, 1),
                    ),
                    elevation: 0,
                  ),
                  iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.expand_more,
                      ),
                      iconSize: 20,
                      iconEnabledColor: Color.fromRGBO(50, 50, 50, 1),
                      iconDisabledColor: Color.fromRGBO(50, 50, 50, 1),
                      openMenuIcon: Icon(Icons.expand_less)),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 0,
                    maxHeight: 200,
                    // width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color.fromARGB(244, 244, 244, 244),
                        border: Border.all(color: Colors.grey[400]!)),
                    offset: const Offset(0, -5),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(5),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              GreyTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  minHeight: 120,
                  maxHeight: 120),

              const SizedBox(height: 24),
              const Text('Media',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Ink(
                decoration: BoxDecoration(
                  color: _selectedImage == null
                      ? Color.fromRGBO(244, 244, 244, 1)
                      : Colors.transparent,
                  // border: Border.all(
                  //   color: Color.fromRGBO(220, 220, 220, 1),
                  //   style: BorderStyle.solid,
                  //   width: _selectedImage == null ? 1.5 : 0,
                  // ),
                  borderRadius: BorderRadius.circular(8),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: InkWell(
                  onTap: () {
                    _pickImageFromGallery();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 150,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            color: _selectedImage == null
                                ? Color.fromRGBO(50, 50, 50, 1)
                                : Colors.white,
                            size: 32,
                            shadows: _selectedImage != null ? [shadow] : [],
                          ),
                          SizedBox(height: 8),
                          Text(
                            _selectedImage == null
                                ? 'Tap to upload an image'
                                : 'Tap to change the image',
                            style: TextStyle(
                                color: _selectedImage == null
                                    ? Color.fromRGBO(50, 50, 50, 1)
                                    : Colors.white,
                                shadows:
                                    _selectedImage != null ? [shadow] : []),
                          ),
                          Text(
                            'Supports: JPG, JPEG and PNG',
                            style: TextStyle(
                              color: _selectedImage == null
                                  ? Color.fromRGBO(50, 50, 50, 1)
                                  : Colors.white,
                              fontSize: 12,
                              shadows: _selectedImage != null
                                  ? [
                                      shadow,
                                    ]
                                  : [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // const Text('No variations are currently available for this item',
              // style: TextStyle(color: Colors.grey)),
              ItemCustomization(
                variantControllers: _variantControllers,
                isExtrasSection: false,
              ),

              const SizedBox(height: 24),

              ItemCustomization(
                variantControllers: _extrasControllers,
                priceControllers: _extrasPriceControllers,
                isExtrasSection: true,
              ),

              // const SizedBox(height: 8),
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
                          controller: _priceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false))),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2C230),
                      // padding: EdgeInsets.zero,
                      elevation: 0, // Removes shadow
                      shadowColor: Colors.transparent, // Ensures no shadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Adjust button size as needed
                      // minimumSize:
                      //     Size(100, 40), // Set minimum width and height
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  const SizedBox(width: 10), // Spacing between buttons
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0, // Removes shadow
                      shadowColor: Colors.transparent, // Ensures no shadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Adjust button size as needed
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

Widget GreyTextField({
  String? label,
  required TextEditingController controller,
  FocusNode? focusNode,
  TextStyle? style,
  double? minHeight = 0,
  double? maxHeight = 55,
  TextInputType? keyboardType,
  Map<String, dynamic>? extraProps, // Capture extra props
}) {
  return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight!, maxHeight: maxHeight!),
      child: TextField(
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top, // Align text to the top
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Color.fromRGBO(50, 50, 50, 1),
              fontSize: 16), // Adjust font size as needed,
          alignLabelWithHint: true,

          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: const Color.fromRGBO(244, 244, 244, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
            ),
          ),
        ),
        style: style ??
            const TextStyle(color: Color.fromRGBO(50, 50, 50, 1), fontSize: 16),
      ));
}
