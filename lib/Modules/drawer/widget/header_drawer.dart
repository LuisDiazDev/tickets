import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../Core/Values/Colors.dart';
import 'package:gap/gap.dart';
import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../../core/utils/size_utils.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return  Container(
      color: StarlinkColors.darkGray,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 100.v,),
          const Gap(45),
        ],
      ),
    );
  }
}
