import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../Widgets/starlink/colors.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: StarlinkColors.darkGray,
      width: double.infinity,
      child: const Column(
        children: [
          SizedBox(height: 100,),
          Gap(45),
        ],
      ),
    );
  }
}
