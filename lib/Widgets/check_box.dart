import 'package:flutter/material.dart';

import '../Core/Values/colors.dart';

class CheckBoxControl extends StatefulWidget {
  final String title;
  final ValueChanged<bool> onChanged;
  final bool checked;
  final GlobalKey? formItemKey;

  const CheckBoxControl({super.key, this.title="", required this.onChanged, checked, this.formItemKey})
      : checked = checked ?? false;

  @override
  State<CheckBoxControl> createState() => _CheckBoxControlState();
}

class _CheckBoxControlState extends State<CheckBoxControl> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10.0),
              child: Text
                (widget.title,
                maxLines: 2,
                style:const TextStyle(
                    backgroundColor: Colors.transparent,
                    color: ColorsApp.secondary,
                    fontFamily: 'DDIN-Bold',
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child:Transform.scale(
              scale: 2.0,
              child: Checkbox(
                key: widget.formItemKey,
                value: isChecked,
                activeColor:ColorsApp.secondary,
                onChanged: (bool? value) {
                  widget.onChanged(value!);
                  setState(() {
                    isChecked = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
