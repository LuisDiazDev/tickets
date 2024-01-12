import 'package:StarTickera/Core/Values/Colors.dart';
import 'package:flutter/material.dart';

class StarlinkTextField extends StatelessWidget {
  final String initialValue;
  final Function(String) onChanged;
  final String title;
  final String textHint;
  final bool isEnabled;
  final String errorText;
  final TextInputType keyboardType;
  final int maxLength;
  final String textSuffix;

  const StarlinkTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.title,
    required this.textHint,
    this.isEnabled = true,
    this.errorText = '',
    this.keyboardType = TextInputType.text,
    this.maxLength = 0,
    this.textSuffix = "",
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: maxLength == 0 ? null : maxLength,
                  enabled: isEnabled,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
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
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Visibility(
                  visible: textSuffix.isNotEmpty,
                  child: Text(
                    textSuffix,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: StarlinkColors.white,
                      fontSize: 14.0,
                      // bold
                      fontFamily: 'DDIN-Bold',
                    ),
                  ),
                ),
              ),
            ],

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
