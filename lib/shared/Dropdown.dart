import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class Dropdown extends StatelessWidget {
  String? selectedValue;
  List<String> options;
  void Function(String value) onChange;
  Dropdown(
      {super.key,
      required this.selectedValue,
      required this.onChange,
      required this.options});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
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
                  color: Styles.inputFieldTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: options
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Styles.inputFieldTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          if (value != null) onChange(value);
        },
        buttonStyleData: ButtonStyleData(
          height: 55,
          // width: 160,
          padding: const EdgeInsets.only(left: 0, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Styles.inputFieldBgColor,
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.expand_more,
            ),
            iconSize: 20,
            iconEnabledColor: Styles.inputFieldTextColor,
            iconDisabledColor: Styles.inputFieldTextColor,
            openMenuIcon: Icon(Icons.expand_less)),
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          maxHeight: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Styles.inputFieldBgColor,
              border: Border.all(color: Styles.inputFieldBorderColor)),
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
    );
  }
}
