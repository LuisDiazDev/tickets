import 'package:StarTickera/Modules/Profiles/widget/form_new_profile.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../Widgets/custom_appbar.dart';
import '../../models/profile_model.dart';
import '../Alerts/AlertCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/ProfileBloc.dart';
import 'bloc/ProfileState.dart';

import 'widget/custom_profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    return BlocProvider(
      create: (context) =>
          ProfileBloc(alertCubit, provider: MkProvider())..init(),
      child: const _BuildHomePage(),
    );
  }
}

class _BuildHomePage extends StatefulWidget {
  const _BuildHomePage({Key? key}) : super(key: key);

  @override
  State<_BuildHomePage> createState() => _BuildHomePageState();
}

class _BuildHomePageState extends State<_BuildHomePage>
    with AutomaticKeepAliveClientMixin<_BuildHomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: StarlinkColors.black,
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "PLANES"),
        body: Stack(
          children: [
            Visibility(
              visible: !state.load && state.profiles.isNotEmpty,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.profiles
                          .where((p) => p.name != "default")
                          .map((e) => CustomProfile(
                        profile: e,
                        onTap: () {
                          showGlobalDrawer(
                              context: context,
                              builder: horizontalDrawerBuilder(
                                  profileBloc,
                                  profileModel: e),
                              direction: AxisDirection.right);
                        },
                        copyTap: () {
                          showGlobalDrawer(
                              context: context,
                              builder: horizontalDrawerBuilder(
                                  profileBloc,
                                  newProfile: true,
                                  profileModel: e),
                              direction: AxisDirection.right);
                        },
                      )),
                      const Gap(45)
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
                visible: !state.load && state.profiles.isEmpty,
                child: Center(
                  child: StarlinkButton(
                    text: 'CREAR NUEVO PLAN',
                    onPressed: () {
                      showGlobalDrawer(
                          context: context,
                          builder: horizontalDrawerBuilder(profileBloc),
                          direction: AxisDirection.right);
                    },
                  ),
                ))
          ],
        ),
        bottomSheet: Visibility(
          visible: state.profiles.isNotEmpty && !state.load,
          child: StarlinkButton(
              text: "CREAR NUEVO PLAN",
              type: ButtonType.primary,
              onPressed: () {
                showGlobalDrawer(
                    context: context,
                    builder: horizontalDrawerBuilder(profileBloc),
                    direction: AxisDirection.right);
              }),
        ),
      );
    });
  }

  WidgetBuilder horizontalDrawerBuilder(ProfileBloc profileBloc,
      {ProfileModel? profileModel, bool newProfile = false}) {
    return (BuildContext context) {
      return Drawer(
        child: FormNewProfileWidget(
          bloc: profileBloc,
          current: profileModel,
          newProfile: newProfile,
        ),
      );
    };
  }
}
