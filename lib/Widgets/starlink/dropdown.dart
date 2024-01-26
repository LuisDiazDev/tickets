import 'package:flutter/material.dart';
import 'colors.dart';

class StarlinkDropdown extends StatelessWidget {
  final void Function(String?) onChanged;
  final List<String> values;
  final String? initialValue;

  const StarlinkDropdown({
    Key? key,
    required this.onChanged,
    required this.values,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: StarlinkColors.gray,
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: StarlinkColors.gray,
            value: initialValue ?? values.first,
            icon: const Icon(Icons.arrow_drop_down, color: StarlinkColors.white),
            onChanged: onChanged,
            items: values
                .map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: StarlinkColors.white, fontFamily: 'DDIN-Bold')),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
