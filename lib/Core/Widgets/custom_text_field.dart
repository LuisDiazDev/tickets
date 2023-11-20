import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tickets/Core/Values/Colors.dart';

class CustomTextField extends StatelessWidget {
  final String initialValue, title;
  final Function(String?) onChanged;

  const CustomTextField(
      {super.key,
      this.title = "",
      this.initialValue = "",
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'poppins_semi_bold',
              fontSize: 18,
              color: ColorsApp.secondary,
              fontWeight: FontWeight.w400
            ),
          ),
          const Gap(4),
          TextFormField(
            initialValue: initialValue,
            onChanged: (str) {
              onChanged(str);
            },
            decoration: InputDecoration(
              filled: true,
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
