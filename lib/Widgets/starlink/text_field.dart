import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class StarlinkTextField extends StatefulWidget {
  final String initialValue;
  final bool obscureText;
  final Function(String) onChanged;
  final String title;
  final String textHint;
  final bool isEnabled,readOnly;
  final String errorText;
  final TextInputType keyboardType;
  final int maxLength;
  final String textSuffix;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const StarlinkTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.title,
    required this.textHint,
    this.readOnly = false,
    this.isEnabled = true,
    this.errorText = '',
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength = 0,
    this.suffixIcon,
    this.textSuffix = "",
     this.validator,
  });

  @override
  State<StarlinkTextField> createState() => _StarlinkTextFieldState();
}

class _StarlinkTextFieldState extends State<StarlinkTextField> {

  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget.obscureText;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StarlinkText(
            widget.title,
            size: 14.0,
            isBold: true,
          ),
          const SizedBox(height: 1.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: StarlinkColors.white,
                  obscureText: _passwordVisible,
                  readOnly: widget.readOnly,
                  key: Key(widget.initialValue.toString()),
                  validator: widget.validator,
                  initialValue: widget.initialValue,
                  maxLength: widget.maxLength == 0 ? null : widget.maxLength,
                  enabled: widget.isEnabled,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(
                    color: StarlinkColors.white,
                    fontSize: 16.0,
                    // bold
                    fontFamily: 'DDIN-Bold',
                  ),
                  decoration: InputDecoration(
                    focusColor: StarlinkColors.white,
                    hoverColor: StarlinkColors.white,
                    hintText: widget.textHint,
                    suffixIcon: widget.obscureText ? IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: StarlinkColors.white,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ):widget.suffixIcon,
                    hintStyle: const TextStyle(
                      color: StarlinkColors.gray,
                      fontSize: 14.0,
                      // bold
                      fontFamily: 'DDIN-Bold',
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: StarlinkColors.white),
                    ),
                    errorBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color: StarlinkColors.red),
                    ),
                    border: const OutlineInputBorder(),
                    fillColor: StarlinkColors.darkGray,
                    enabledBorder: widget.errorText.isNotEmpty
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: StarlinkColors.red),
                          )
                        : const OutlineInputBorder(
                            borderSide: BorderSide(color: StarlinkColors.gray),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Visibility(
                visible: widget.textSuffix.isNotEmpty,
                child: Expanded(
                  child: Text(
                    widget.textSuffix,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: StarlinkColors.white,
                      fontSize: 16.0,
                      // bold
                      fontFamily: 'DDIN-Bold',
                    ),
                  ),
                ),
              )
            ],
          ),
          Visibility(
            visible: widget.errorText.isNotEmpty,
            child: Text(
              widget.errorText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: StarlinkColors.red,
                fontSize: 16.0,
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
