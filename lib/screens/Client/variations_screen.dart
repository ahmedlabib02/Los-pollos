import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/screens/Client/add_menu_item_screen.dart';

class VariationsScreen extends StatefulWidget {
  final String header;
  final String textLabel;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> priceControllers;

  final bool? includePrice;

  const VariationsScreen(
      {super.key,
      required this.header,
      required this.textLabel,
      required this.controllers,
      required this.focusNodes,
      required this.priceControllers,
      this.includePrice});

  @override
  _VariationsScreenState createState() => _VariationsScreenState();
}

class _VariationsScreenState extends State<VariationsScreen> {
  String _header = "";
  String _textLabel = "";
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _priceControllers = [];
  List<FocusNode> _focusNodes = [];
  bool _includePrice = false;

  bool _canAdd = true; // Determines whether the "Add" button is enabled

  @override
  void initState() {
    super.initState();
    _header = widget.header;
    _textLabel = widget.textLabel;
    _controllers = widget.controllers;
    _focusNodes = widget.focusNodes;
    _priceControllers = widget.priceControllers;
    _includePrice =
        widget.includePrice ?? false; // Use the provided value or the default
  }

  void _addVariantField() {
    setState(() {
      FocusScope.of(context).unfocus();

      final controller = TextEditingController();
      final priceController = TextEditingController();
      final focusNode = FocusNode();

      controller.addListener(() {
        // Enable "Add" button if the last input field is non-empty
        setState(() {
          _canAdd = _controllers.last.text.isNotEmpty &&
              (_includePrice ? _priceControllers.last.text.isNotEmpty : true);
        });
      });

      _controllers.add(controller);
      _focusNodes.add(focusNode);

      if (_includePrice) {
        priceController.addListener(() {
          // Enable "Add" button if the last input field is non-empty
          setState(() {
            _canAdd = _controllers.last.text.isNotEmpty &&
                _priceControllers.last.text.isNotEmpty;
          });
        });
        _priceControllers.add(priceController);
      }

      _canAdd = false; // Disable the "Add" button initially

      // Use addPostFrameCallback to ensure UI is ready before focusing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
    });
  }

  void _removeVariantField(int index) {
    setState(() {
      if (_focusNodes[index].hasFocus) {
        FocusScope.of(context).unfocus(); // Unfocus before removing
      }

      _controllers[index].dispose(); // Dispose of the controller
      _focusNodes[index].dispose(); // Dispose of the focus node

      _controllers.removeAt(index);
      _focusNodes.removeAt(index);

      if (_includePrice) {
        _priceControllers[index].dispose(); // Dispose of the controller
        _priceControllers.removeAt(index);
      }

      _canAdd = _controllers.isEmpty ||
          (_controllers.last.text.isNotEmpty &&
              (_includePrice ? _priceControllers.last.text.isNotEmpty : true));
    });
  }

  @override
  void dispose() {
    // Dispose of all controllers and focus nodes when the screen is disposed
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    if (_includePrice) {
      for (final priceController in _priceControllers) {
        priceController.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _header,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _canAdd ? _addVariantField : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canAdd ? Color(0xFFF2C230) : Colors.grey,
                elevation: 0, // Removes shadow
                shadowColor: Colors.transparent, // Ensures no shadow
                shape: CircleBorder(), // Makes the button circular
                minimumSize: Size(40.0, 40.0), // Adjust size as needed
                padding: EdgeInsets.zero, // Remove padding for a clean circle
              ),
              child: Icon(Icons.add, color: Colors.black),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _controllers.isEmpty
            ? Text(
                'No variations are currently available for this item ${_includePrice}',
                style: TextStyle(color: Color.fromRGBO(116, 116, 116, 1)),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: _controllers.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 60,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Dismissible(
                          key: ValueKey(_controllers[index]),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            _removeVariantField(index);
                          },
                          child: _includePrice
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: GreyTextField(
                                            controller: _controllers[index],
                                            focusNode: _focusNodes[index],
                                            label: 'Base Price')),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: GreyTextField(
                                            label: 'Discount (%)',
                                            controller:
                                                _priceControllers[index])),
                                  ],
                                )
                              : GreyTextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  label: _textLabel),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
