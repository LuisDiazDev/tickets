import 'package:StarTickera/Data/Services/navigator_service.dart';
import 'package:StarTickera/Modules/Clients/bloc/ClientState.dart';
import 'package:StarTickera/Modules/Clients/widget/custom_client_widget.dart';
import 'package:StarTickera/Modules/Clients/widget/form_new_clients.dart';
import 'package:StarTickera/models/ticket_model.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../Routes/Route.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/button.dart';
import '../Alerts/AlertCubit.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'bloc/ClientsBloc.dart';
import 'bloc/ClientsEvents.dart';

class ListClientPage extends StatelessWidget {
  const ListClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) => ClientsBloc(alertCubit,
          sessionCubit: sessionCubit, provider: MkProvider())
        ..init(),
      child: const _BuildListClientPage(),
    );
  }
}

class _BuildListClientPage extends StatefulWidget {
  const _BuildListClientPage();

  @override
  State<_BuildListClientPage> createState() => _BuildListClientPageState();
}

class _BuildListClientPageState extends State<_BuildListClientPage> {
  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final clientBloc = BlocProvider.of<ClientsBloc>(context);
    return BlocBuilder<ClientsBloc, ClientsState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: StarlinkColors.black,
          drawer: const DrawerCustom(),
          appBar: customAppBar(title: "Clientes"),
          body: Container(
            color: Colors.transparent,
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: StarlinkColors.white,
                      child: ListTile(
                        leading: const Icon(
                          EvaIcons.arrowCircleDownOutline,
                          color: StarlinkColors.green,
                          size: 42,
                        ),
                        title: const Text(
                          "Total de Clientes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: StarlinkColors.black,
                            fontFamily: 'DDIN-Bold',
                          ),
                        ),
                        subtitle: state.load
                            ? const CircularProgressIndicator()
                            : Text(
                                "${clientBloc.state.clients.length}",
                                style: const TextStyle(
                                    color: StarlinkColors.black,
                                    fontFamily: 'DDIN',
                                    fontSize: 22),
                              ),
                      ),
                    )),
                const Gap(10),
                Column(
                  children: state.clients
                      .map((c) => CustomClient(
                            client: c,
                            copyTap: () {
                              clientBloc.add(ResetClient(c));
                            },
                          ))
                      .toList(),
                )
              ],
            ),
          ),
          bottomSheet: StarlinkButton(
              text: "Registrar Cliente",
              type: ButtonType.primary,
              onPressed: () {
                if (state.profiles.isEmpty) {
                  alertCubit.showInfoDialog(
                    AlertInfo("Sin Planes disponibles", "Cree un plan primero"),
                  );
                  NavigatorService.pushNamed(Routes.clientProfile);
                } else {
                  showGlobalDrawer(
                      context: context,
                      builder: horizontalDrawerBuilder(bloc: clientBloc),
                      direction: AxisDirection.right);
                }
              }));
    });
  }

  WidgetBuilder horizontalDrawerBuilder(
      {bool newClient = false,
      required ClientsBloc bloc,
      TicketModel? currentClient}) {
    return (BuildContext context) {
      return Drawer(
        child: FormClientWidget(
          bloc: bloc,
          current: currentClient,
          newClient: newClient,
        ),
      );
    };
  }
}
