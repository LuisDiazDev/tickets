import 'package:startickera/Widgets/starlink/text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'colors.dart';

class StarlinkButtonGroup extends StatefulWidget {
  final List<String>? labels;
  final List<Widget>? widgets;
  final Function(int)? onChanged;
  final int initialIndex;

  const StarlinkButtonGroup({
    required this.labels,
    required this.widgets,
    required this.onChanged,
    this.initialIndex = 0,
    super.key,
  });

  @override
  _StarlinkButtonGroupState createState() => _StarlinkButtonGroupState();
}

class _StarlinkButtonGroupState extends State<StarlinkButtonGroup> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: StarlinkColors.darkGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IntrinsicWidth(
              child: Row(
                children: List.generate(widget.labels!.length, (index) => _buildButton(index)),
              ),
            ),
          ),
        ),
        const Gap(20),
        if (widget.widgets != null && widget.widgets!.isNotEmpty)
          Expanded(
            child: widget.widgets![_selectedIndex],
          ),
      ],
    );
  }


  Widget _buildButton(int index) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, right: 1.0),
      child: IntrinsicWidth(
        stepWidth: 40,
        child: GestureDetector(
          onTap: () {
            widget.onChanged?.call(index);
            setState(() {
              _selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ? StarlinkColors.white : StarlinkColors.darkGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: StarlinkText(
                widget.labels![index].toUpperCase(),
                color: isSelected ? StarlinkColors.darkGray : StarlinkColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
