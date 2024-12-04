import 'package:flutter/material.dart';
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
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final List<TextEditingController> _variantControllers =
      []; // Controllers for input fields
  final List<TextEditingController> _variantPriceControllers = [];
  final List<FocusNode> _variantFocusNodes = []; // Focus nodes for input fields

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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              GreyTextField(label: 'Title', controller: _titleController),
              const SizedBox(height: 16),
              GreyTextField(label: 'Category', controller: _categoryController),
              const SizedBox(height: 16),
              GreyTextField(
                  label: 'Description', controller: _descriptionController),
              const SizedBox(height: 24),
              const Text('Media',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                      color: Colors.grey, style: BorderStyle.solid, width: 1.5),
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
              SizedBox(
                height: 300, // Specify a height (adjust as needed)
                child: VariationsScreen(
                  header: "Variations",
                  textLabel: "Variant",
                  controllers: _variantControllers,
                  focusNodes: _variantFocusNodes,
                  priceControllers: _variantPriceControllers,
                  includePrice: true,
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Extras',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  FloatingActionButton(
                    onPressed: () {},
                    mini: true,
                    backgroundColor: const Color(0xFFF2C230),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('No extras are currently available for this item',
                  style: TextStyle(color: Color.fromRGBO(116, 116, 116, 1))),
              const SizedBox(height: 24),
              const Text('Pricing',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: GreyTextField(
                          label: 'Base Price',
                          controller: _basePriceController)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: GreyTextField(
                          label: 'Discount (%)',
                          controller: _discountController)),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print(_variantControllers[0].text);
                        print(_variantControllers[1].text);
                        // print(_variantControllers[2].text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF2C230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Save changes',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Discard',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50)
                ],
              ),
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
  Map<String, dynamic>? extraProps, // Capture extra props
}) {
  return TextField(
    maxLines: null,
    controller: controller,
    focusNode: focusNode,
    decoration: InputDecoration(
      labelText: label,
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
    style: style ?? const TextStyle(fontSize: 16),
  );
}
