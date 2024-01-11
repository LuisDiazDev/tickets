import 'package:StarTickera/Core/Values/Colors.dart';
import 'package:flutter/material.dart';

class StarlinkTextField extends StatelessWidget {
  final String initialValue;
  final Function(String) onChanged;
  final String title;
  final String textHint;
  final bool isEnabled;
  final String errorText;

  const StarlinkTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.title,
    required this.textHint,
    this.isEnabled = true,
    this.errorText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: StarlinkColors.white,
              fontSize: 12.0,
              // bold
              fontFamily: 'DDIN-Bold',
            ),
          ),
          const SizedBox(height: 1.0),
          TextField(
            enabled: isEnabled,
            onChanged: onChanged,
            style: const TextStyle(
              color: StarlinkColors.white,
              fontSize: 14.0,
              // bold
              fontFamily: 'DDIN-Bold',
            ),
            decoration: InputDecoration(
              hintText: textHint,
              hintStyle: const TextStyle(
                color: StarlinkColors.gray,
                fontSize: 12.0,
                // bold
                fontFamily: 'DDIN-Bold',
              ),
              border: const OutlineInputBorder(),
              fillColor: StarlinkColors.transparent,
              enabledBorder: errorText.isNotEmpty
                  ? const OutlineInputBorder(
                      borderSide: BorderSide(color: StarlinkColors.red),
                    )
                  : const OutlineInputBorder(
                      borderSide: BorderSide(color: StarlinkColors.gray),
                    ),
            ),
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: initialValue,
                selection: TextSelection.collapsed(offset: initialValue.length),
              ),
            ),
          ),
          Visibility(
            visible: errorText.isNotEmpty,
            child: Text(
              errorText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: StarlinkColors.red,
                fontSize: 14.0,
                // bold
                fontFamily: 'DDIN',
              ),
            ),
          ),
          const SizedBox(height: 1.0),
        ],
      ),
    );
  }
}
