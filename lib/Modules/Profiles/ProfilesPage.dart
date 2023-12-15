import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickets/Modules/Profiles/widget/form_new_profile.dart';
import 'package:tickets/models/profile_model.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../Widgets/custom_appbar.dart';
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
          ProfileBloc(alertCubit, provider: TicketProvider())..init(),
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
        backgroundColor: Colors.white,
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "Mis Planes"),
        body: Stack(
          children: [
            Visibility(
              visible: state.load,
              child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: ColorsApp.green,
                    ),
                  )),
            ),
            Visibility(
              visible: !state.load && state.profiles.isNotEmpty,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    children: state.profiles
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
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: !state.load && state.profiles.isEmpty,
                child: Center(
                  child: MaterialButton(
                    height: 45,
                    shape: StadiumBorder(),
                    color: ColorsApp.secondary,
                    onPressed: () {
                      showGlobalDrawer(
                          context: context,
                          builder: horizontalDrawerBuilder(profileBloc),
                          direction: AxisDirection.right);
                    },
                    child: const Text(
                      'Crear Nuevo Plan',
                      style: TextStyle(
                          color: ColorsApp.primary,
                          fontFamily: "poppins_bold",
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                ))
          ],
        ),
        bottomSheet: Visibility(
          visible: state.profiles.isNotEmpty && !state.load,
          child: GestureDetector(
            onTap: () {
              showGlobalDrawer(
                  context: context,
                  builder: horizontalDrawerBuilder(profileBloc),
                  direction: AxisDirection.right);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 46,
                  decoration: const BoxDecoration(color: ColorsApp.secondary),
                  child: const Center(
                    child: Text(
                      'Agregar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        height: 0.08,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  WidgetBuilder horizontalDrawerBuilder(ProfileBloc profileBloc,
      {ProfileModel? profileModel}) {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          // Navigator.of(context).pop();
        },
        child: Drawer(
          child: Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
              ),
              child: FormNewProfileWidget(
                bloc: profileBloc,
                current: profileModel,
              )),
        ),
      );
    };
  }
}
