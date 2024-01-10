import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../Core/Values/Colors.dart';
import 'custom_text_field.dart';

class CustomDropDown extends StatefulWidget {
  final String title, initialDropdown, initialString;
  final List item;
  final Function(String?) onChange;
  final TextInputType? keyboard;

  const CustomDropDown(
      {super.key,
      this.keyboard,
      this.initialString = "1",
      this.title = "",
      this.item = const [],
      required this.onChange,
      this.initialDropdown = ""});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String currentSelected;
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentSelected = widget.initialDropdown;
    _controller = TextEditingController(text: widget.initialString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .3,
                child: CustomTextField(
                  keyboard: widget.keyboard,
                  controller: _controller,
                  onChanged: (str) {
                    widget.onChange(str! + currentSelected);
                  },
                  initialValue: "1",
                ),
              ),
              const Gap(10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .39,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: currentSelected,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  items: widget.item
                      .map((p) => DropdownMenuItem<String>(
                            value: p ?? "",
                            child: Text(p == "S" ? p.replaceAll("S", "\$") : formatString(p) ?? ""),
                          ))
                      .toList(),
                  onChanged: (str) {
                    widget.onChange(_controller.value.text + str!);
                    currentSelected = str;
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 6),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }



  String formatString(String str){
    if(str == "m"){
      return "Minutos";
    }else if(str == "h"){
      return "Hora";
    }else if(str == "d"){
      return "Dias";
    }else if(str == "s"){
      return "Semanas";
    }
    return str;
  }
}
