import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tickets/Core/Values/Colors.dart';

class CustomTextField extends StatefulWidget {
  final String initialValue, title, leathig;
  final Function(String?) onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final bool password;

  const CustomTextField(
      {super.key,
      this.keyboard,
      this.password = false,
      this.leathig = "",
      this.controller,
      this.title = "",
      this.initialValue = "",
      required this.onChanged});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: widget.title != ""
          ? const EdgeInsets.symmetric(
              horizontal: 16,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: widget.title != "",
              child: Column(
                children: [
                  const Gap(10),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontFamily: 'poppins_semi_bold',
                        fontSize: 18,
                        color: ColorsApp.secondary,
                        fontWeight: FontWeight.w400),
                  ),
                  const Gap(4),
                ],
              )),
          TextField(
            obscureText:widget.password,
            keyboardType: widget.keyboard ?? TextInputType.text,
            controller: _controller,
            onChanged: (str) {
              widget.onChanged(str);
            },

            decoration: InputDecoration(
              filled: true,
              suffix: Text(widget.leathig),
              fillColor: const Color.fromARGB(255, 241, 239, 239),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 241, 239, 239),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 241, 239, 239),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 241, 239, 239),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
