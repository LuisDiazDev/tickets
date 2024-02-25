import 'package:startickera/Widgets/starlink/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../Data/Provider/mikrotik/mk_provider.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/colors.dart';
import '../../models/profile_model.dart';
import '../../models/ticket_model.dart';
import '../Alerts/alert_cubit.dart';
import '../Session/session_cubit.dart';
import '../drawer/drawer.dart';
import 'bloc/tickets_bloc.dart';
import 'bloc/tickets_state.dart';
import 'widgets/ticket_widget.dart';


class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) =>
          TicketsBloc(alertCubit, provider: MkProvider(sessionCubit))..init(),
      child: const _BuildTicketsPage(),
    );
  }
}

class _BuildTicketsPage extends StatefulWidget {
  const _BuildTicketsPage();

  @override
  State<_BuildTicketsPage> createState() => _BuildTicketsPageState();
}

class _BuildTicketsPageState extends State<_BuildTicketsPage>
    with AutomaticKeepAliveClientMixin<_BuildTicketsPage> {
  @override
  bool get wantKeepAlive => true;
  List<TicketModel> tickets = [];
  List<ProfileModel> profiles = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      tickets = state.tickets
          .where((t) =>
              t.profile != "" &&
              t.profile != "default" &&
              !t.name!.contains("-"))
          .toList();
      profiles = state.profiles
          .where((t) =>
              t.name != "" && t.name != "default" && !t.name!.contains("-"))
          .toList();
      return Scaffold(
        backgroundColor: StarlinkColors.black,
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "TICKETS VENDIDOS"),
        body: Builder(
          builder: (context) {
            if (!state.load && tickets.isEmpty){
              return Center(
                child: Column(
                  children: [
                    const Gap(100),
                    StarlinkText(
                      "No hay tickets vendidos",
                      size: 18,
                      isBold: true,
                    )],
                ),
              );
            }
            if (!state.load && tickets.isEmpty) {
              return                 Center(
                  child: StarlinkText(
                    "Debes crear un plan primero",
                    size: 18,
                    isBold: true,
                  ),
                );
            }
            return buildTicketListWidget(context, state);
          }
        ),
      );
    });
  }

  Container buildTicketListWidget(BuildContext context, TicketsState state) {
    return Container(
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Builder(builder: (context) {
                  return Column(
                    children: [
                      ...tickets.map((e) => Builder(builder: (context) {
                            var profile = state.profiles.firstWhere(
                                (p) => p.fullName == e.profile,
                                orElse: () =>
                                    ProfileModel(name: "", onLogin: ""));
                            return CustomTicketWidget(
                              ticket: e,
                              profile: profile,
                            );
                          })),
                      const SizedBox(
                        height: 200,
                      ),
                    ],
                  );
                }),
              ),
            );
  }
}
