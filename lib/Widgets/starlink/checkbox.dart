import 'package:flutter/material.dart';

import 'colors.dart';

class StarlinkCheckBox extends StatefulWidget {
  final String title;
  final Function(bool?) onChanged;
  final bool initialState;

  const StarlinkCheckBox({
    super.key,
    required this.title,
    required this.onChanged,
    required this.initialState,
  });

  @override
  State<StarlinkCheckBox> createState() => _CustomCheckboxTileState();
}

class _CustomCheckboxTileState extends State<StarlinkCheckBox> {
  late bool isChecked;

  @override
  Widget build(BuildContext context) {
    isChecked = widget.initialState;
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChanged(isChecked);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: StarlinkColors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'DDIN',
              fontSize: 14.0,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: isChecked ? StarlinkColors.white : StarlinkColors.gray,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      size: 24.0,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.check,
                      size: 24.0,
                      color: Colors.transparent,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
