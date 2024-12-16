import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/screens/Manager/add_menu_item_screen.dart';
import 'package:los_pollos_hermanos/shared/GreyTextField.dart';

class ItemCustomization extends StatefulWidget {
  final List<TextEditingController> variantControllers;
  final List<TextEditingController>? priceControllers;
  final bool isExtrasSection;

  const ItemCustomization({
    super.key,
    required this.variantControllers,
    this.priceControllers,
    this.isExtrasSection = false,
  });

  @override
  _ItemCustomizationState createState() => _ItemCustomizationState();
}

class _ItemCustomizationState extends State<ItemCustomization> {
  bool _canAdd = true; // Determines whether the "Add" button is enabled
  final List<FocusNode> variantFocusNodes = [];

  void _addVariantField() {
    setState(() {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      // Add listeners to the new controller and the price controller if in extras section
      controller.addListener(_updateCanAdd);

      widget.variantControllers.add(controller);
      variantFocusNodes.add(focusNode);

      if (widget.isExtrasSection) {
        final priceController = TextEditingController();
        priceController.addListener(_updateCanAdd);
        widget.priceControllers!.add(priceController);
      }

      _canAdd = false; // Disable "Add" button initially

      // Auto-focus the newly added field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
    });
  }

// Method to check if "Add" button should be enabled
  void _updateCanAdd() {
    setState(() {
      bool allVariantFieldsFilled = widget.variantControllers
          .every((controller) => controller.text.isNotEmpty);
      bool allPriceFieldsFilled = widget.isExtrasSection
          ? widget.priceControllers!
              .every((controller) => controller.text.isNotEmpty)
          : true;

      _canAdd = allVariantFieldsFilled && allPriceFieldsFilled;
    });
  }

  void _removeVariantField(int index) {
    setState(() {
      widget.variantControllers[index].dispose(); // Dispose of the controller
      variantFocusNodes[index].dispose(); // Dispose of the focus node

      widget.variantControllers.removeAt(index);
      variantFocusNodes.removeAt(index);

      if (widget.isExtrasSection) {
        widget.priceControllers?[index].dispose();
        widget.priceControllers?.removeAt(index);
      }

      _canAdd = widget.variantControllers.isEmpty ||
          widget.variantControllers.last.text.isNotEmpty &&
              (widget.isExtrasSection
                  ? widget.priceControllers?.last.text.isNotEmpty ?? true
                  : true);
    });
  }

  @override
  void dispose() {
    // Dispose of all controllers and focus nodes when the screen is disposed
    for (final controller in widget.variantControllers) {
      controller.dispose();
    }
    for (final focusNode in variantFocusNodes) {
      focusNode.dispose();
    }
    if (widget.isExtrasSection) {
      for (final priceController in widget.priceControllers ?? []) {
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
              widget.isExtrasSection ? "Extras" : "Variations",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _canAdd ? _addVariantField : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canAdd ? Color(0xFFF2C230) : Colors.grey,
                elevation: 0, // Removes shadow
                shadowColor: Colors.transparent, // Ensures no shadow
                shape: CircleBorder(), // Makes the button circular
                minimumSize: Size(32.0, 32.0), // Adjust size as needed
                padding: EdgeInsets.zero, // Remove padding for a clean circle
              ),
              child: Icon(Icons.add, color: Colors.black, size: 20),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        widget.variantControllers.isEmpty
            ? Text(
                widget.isExtrasSection
                    ? 'No extras are currently available for this item'
                    : 'No variations are currently available for this item',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(50, 50, 50, 1)),
              )
            : ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 0,
                  maxHeight: 300,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.variantControllers.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      // height: 60,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Dismissible(
                          key: ValueKey(widget.variantControllers[index]),
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
                          child: widget.isExtrasSection
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: GreyTextField(
                                        controller:
                                            widget.variantControllers[index],
                                        focusNode: variantFocusNodes[index],
                                        label: 'Extra',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: GreyTextField(
                                          controller:
                                              widget.priceControllers![index],
                                          label: 'Price',
                                          keyboardType: TextInputType.number),
                                    ),
                                  ],
                                )
                              : GreyTextField(
                                  controller: widget.variantControllers[index],
                                  focusNode: variantFocusNodes[index],
                                  label: 'Variant',
                                ),
                        ),
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }
}
