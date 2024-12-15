import 'package:flutter/material.dart';

class GreyTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final double? minHeight;
  final double? maxHeight;
  final TextInputType? keyboardType;
  final Map<String, dynamic>? extraProps; // Capture extra props

  const GreyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.style,
    this.minHeight = 0,
    this.maxHeight = 55,
    this.keyboardType,
    this.extraProps, // Capture extra props
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: minHeight!, maxHeight: maxHeight!),
        child: TextField(
          keyboardType: keyboardType ?? TextInputType.text,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top, // Align text to the top
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
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
              const TextStyle(
                  color: Color.fromRGBO(50, 50, 50, 1), fontSize: 16),
        ));
  }
}
