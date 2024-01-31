import 'package:startickera/Modules/Home/widgets/bt_state_widget.dart';
import 'package:startickera/Modules/Home/widgets/scann_qr_button.dart';
import 'package:startickera/Widgets/starlink/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../Data/Provider/mk_provider.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/qr_scan.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/section_title.dart';
import '../../Widgets/starlink/text_style.dart';
import '../Alerts/alert_cubit.dart';
import '../Session/session_cubit.dart';
import '../drawer/drawer.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_events.dart';
import 'bloc/home_state.dart';
import 'widgets/custom_plan_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) =>
          HomeBloc(alertCubit, sessionCubit, provider: MkProvider())..init(),
      child: const _BuildHomePage(),
    );
  }
}

class _BuildHomePage extends StatefulWidget {
  const _BuildHomePage();

  @override
  State<_BuildHomePage> createState() => _BuildHomePageState();
}

class _BuildHomePageState extends State<_BuildHomePage>
    with AutomaticKeepAliveClientMixin<_BuildHomePage> {
  bool needSelectPlan = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final home = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      var filteredProfiles =
          state.profiles.where((t) => t.name != "" && t.name != "default");
      late Widget? bstate;

      if (home.sessionCubit.state.cfg != null &&
          (home.sessionCubit.state.cfg!.bluetoothDevice != null ||
              home.sessionCubit.state.cfg!.lastIdBtPrint != "")) {
        bstate = BtStateWidget(
          bluetoothDevice: home.sessionCubit.state.cfg!.bluetoothDevice,
          sessionBloc: home.sessionCubit,
        );
      } else {
        bstate = null;
      }

      return Scaffold(
        backgroundColor: StarlinkColors.black,
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "VENTA DE TICKETS", action: bstate),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Visibility(
                  visible: filteredProfiles.isNotEmpty && !state.load,
                  child: Column(children: [
                    const Gap(12),
                    ScanVirtualTicketButton(
                      onPressed: () async {
                        String? user = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanQrScreen()),
                        );
                        if (user != null) {
                          setState(() {
                            needSelectPlan = true;
                          });
                          home.add(VirtualTicketScanned(user));
                        }
                      },
                    ),
                    const Gap(30),
                    Visibility(
                      visible: needSelectPlan,
                      child: Column(
                        children: [
                          const Gap(10),
                          StarlinkCard(type: InfoContextType.info, title: "SELECCIONE UN PLAN",
                              message: "El plan seleccionado se asignará al usuario escaneado '${home.state.currentUser}'"),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !needSelectPlan,
                      child: const StarlinkSectionTitle(
                          title: "IMPRIMIR NUEVOS TICKETS",
                          alignment: Alignment.center,
                      ),
                    ),
                    const Gap(10),
                    Builder(builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * .591,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: filteredProfiles
                                .map((e) => CustomPlanWidget(
                                      profile: e,
                                      generatedUser: (user) {
                                        var duration =
                                            e.metadata?.usageTime ?? "";
                                        var price = e.metadata?.price ?? "";
                                        var limit = e.metadata?.dataLimit ?? 0;
                                        home.add(GeneratedTicket(
                                            e.metadata!.toMikrotiketNameString(
                                                e.name ?? ""),
                                            user,
                                            duration,
                                            price.toString(),
                                            limitMb: limit,
                                            isVirtualTicket: needSelectPlan
                                        ));
                                        setState(() {
                                          if (needSelectPlan) {
                                            needSelectPlan = false;
                                          }
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    }),
                  ]),
                ),
                Visibility(
                    visible: filteredProfiles.isEmpty && !state.load,
                    child: Center(
                      child: StarlinkText(
                        "SIN PLANES DISPONIBLES",
                        size: 18,
                        isBold: true,
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
