import 'package:flutter/material.dart';

import '../../Core/Values/Colors.dart';

// class StarlinkCheckBox extends StatelessWidget {
//   final String text;
//   final bool isMandatory;
//   final bool value;
//   final Function(bool) onChanged;
//
//   const StarlinkCheckBox({
//     Key? key,
//     required this.text,
//     required this.isMandatory,
//     required this.value,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         text,
//         style: TextStyle(
//           fontWeight: isMandatory ? FontWeight.bold : FontWeight.normal,
//           color: isMandatory ? Colors.black : Colors.grey,
//         ),
//       ),
//       trailing: Switch(
//         value: value,
//         onChanged: onChanged,
//       ),
//       onTap: () {
//         onChanged(!value);
//       },
//     );
//   }
// }

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
              fontFamily: 'DDIN-Bold',
              fontSize: 16.0,
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
