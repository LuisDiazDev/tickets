import 'package:startickera/Modules/Reports/widgets/UserActive/bloc/active_tickets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Values/colors.dart';
import '../../../../Data/Provider/mikrotik/mk_provider.dart';
import '../../../../Widgets/starlink/colors.dart';
import '../../../Session/session_cubit.dart';
import 'bloc/active_tickets_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class ActiveTicketsWidget extends StatelessWidget {
  const ActiveTicketsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) => ActiveTicketsBloc(provider: MkProvider(sessionCubit))..init(),
      child: const _BuildActiveTicketsPage(),
    );
  }
}

class _BuildActiveTicketsPage extends StatefulWidget {
  const _BuildActiveTicketsPage();

  @override
  State<_BuildActiveTicketsPage> createState() =>
      _BuildActiveTicketsPageState();
}

class _BuildActiveTicketsPageState extends State<_BuildActiveTicketsPage> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveTicketsBloc, ActiveTicketState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: StarlinkColors.white,
          child: ListTile(
            leading: const Icon(
              EvaIcons.personDoneOutline,
              color: Colors.green,
              size: 42,
            ),
            title: const Text(
              "Usuarios Activos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                fontFamily: 'DDIN-Bold',
              ),
            ),
            subtitle: state.load
                ? const CircularProgressIndicator(
              color: Colors.white,
            )
                : Text(
                    "${state.ticketsA.isNotEmpty ? state.ticketsA.length : "No hay usuarios conectados"}",
                    style: const TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: 'DDIN',
                        fontSize: 22),
                  ),
            trailing: IconButton(
              onPressed: () async {
                await showActiveListPopUp(context, state);
              },
              icon: const Icon(EvaIcons.eyeOff2),
            ),
          ),
        ),
      );
    });
  }

  Future showActiveListPopUp(
      BuildContext context, ActiveTicketState state) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Usuarios Activos  (${state.ticketsA.length})",
                        style: const TextStyle(fontSize: 24.0),
                      ),
                      const Icon(
                        EvaIcons.personDoneOutline,
                        color: ColorsApp.green,
                        size: 30.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height*.4,
                      child: // get devices
                          SingleChildScrollView(
                        child: Column(
                          children: state.ticketsA
                              .map((e) => Card(
                                color: StarlinkColors.white,
                                child: ListTile(
                                      title: Text(e.user ?? ""),
                                      subtitle: Text("IP: ${e.address} \nMac: ${e.macAddress}"),
                                      trailing: IconButton(onPressed: (){},icon: const Icon(EvaIcons.trash2),),
                                ),

                              ))
                              .toList(),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
