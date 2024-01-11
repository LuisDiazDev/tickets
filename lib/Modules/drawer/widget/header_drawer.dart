import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../Core/Values/Colors.dart';
import 'package:gap/gap.dart';
import '../../../core/utils/size_utils.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return  Container(
      color: StarlinkColors.black,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 100.v,),
          Text("title_drawer".tr,style:const TextStyle(
              color: ColorsApp.primary,
              fontFamily: 'poppins_bold',
              fontWeight: FontWeight.w600,
              fontSize: 26
          ),),
          const Gap(45),
        ],
      ),
    );
  }
}
