import 'package:StarTickera/Modules/Clients/bloc/ClientState.dart';
import 'package:StarTickera/Modules/Clients/widget/form_new_profile.dart';
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
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/ClientsBloc.dart';
import 'widget/custom_profile_widget.dart';

class ClientsProfilePage extends StatelessWidget {
  const ClientsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) =>
      ClientsBloc(alertCubit,sessionCubit: sessionCubit, provider: MkProvider())..init(),
      child: const _BuildClientsProfilePage(),
    );
  }
}

class _BuildClientsProfilePage extends StatefulWidget {
  const _BuildClientsProfilePage();

  @override
  State<_BuildClientsProfilePage> createState() => _BuildClientsProfilePageState();
}

class _BuildClientsProfilePageState extends State<_BuildClientsProfilePage>
    with AutomaticKeepAliveClientMixin<_BuildClientsProfilePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final clientBloc = BlocProvider.of<ClientsBloc>(context);

    return BlocBuilder<ClientsBloc, ClientsState>(builder: (context, state) {
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
                                  clientBloc,
                                  profileModel: e),
                              direction: AxisDirection.right);
                        },
                        copyTap: () {
                          showGlobalDrawer(
                              context: context,
                              builder: horizontalDrawerBuilder(
                                  clientBloc,
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
                          builder: horizontalDrawerBuilder(clientBloc),
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
                    builder: horizontalDrawerBuilder(clientBloc),
                    direction: AxisDirection.right);
              }),
        ),
      );
    });
  }

  WidgetBuilder horizontalDrawerBuilder(ClientsBloc profileBloc,
      {ProfileModel? profileModel, bool newProfile = false}) {
    return (BuildContext context) {
      return Drawer(
        child: FormNewProfileClientWidget(
          bloc: profileBloc,
          current: profileModel,
          newProfile: newProfile,
        ),
      );
    };
  }
}
