import 'package:flutter/material.dart';

class CustomsTextFields extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initial;
  final TextInputType textInputType;
  final Function(String)? onChange;
  final double? textSized;
  final TextAlign textAlign;
  const CustomsTextFields(
      {super.key,this.initial,this.textAlign=TextAlign.start, this.hintText = "example",this.prefixIcon, this.obscureText = false,this.suffixIcon,this.onChange,this.textInputType=TextInputType.text,this.textSized});

  @override
  State<CustomsTextFields> createState() => _CustomsTextFieldsState();
}

class _CustomsTextFieldsState extends State<CustomsTextFields> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(4),
      child: TextFormField(
        key: Key( widget.initial.toString()), // <- Magic!
        textAlign: widget.textAlign,
        keyboardType: widget.textInputType,
        obscureText: !_passwordVisible,
        initialValue: widget.initial,
        onChanged: widget.onChange,
        style: TextStyle(
          fontSize: widget.textSized
        ),
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xFF123258), width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xFFD3E3F1), width: 2.0),
            ),
            hintText: widget.hintText,

            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText ? IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ):widget.suffixIcon
        ),
      ),
    );
  }
}
