import 'package:flutter/material.dart';
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
              GreyDropdown(
                items: const ['Option 1', 'Option 2', 'Option 3'],
                label: 'Category',
                selectedValue: _category,
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
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  border: Border.all(
                      color: Color.fromRGBO(220, 220, 220, 1),
                      style: BorderStyle.solid,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, color: Colors.grey, size: 32),
                      SizedBox(height: 8),
                      Text('Tap to upload',
                          style: TextStyle(color: Colors.grey)),
                      Text('Supports: JPG, JPEG and PNG',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
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
                          label: 'Base Price', controller: _priceController)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: GreyTextField(
                          label: 'Discount (%)',
                          controller: _discountController)),
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
  Map<String, dynamic>? extraProps, // Capture extra props
}) {
  return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight!, maxHeight: maxHeight!),
      child: TextField(
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
