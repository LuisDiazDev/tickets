import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tickets/Core/localization/app_localization.dart';
import 'package:tickets/Modules/Session/SessionCubit.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../Core/Widgets/custom_appbar.dart';
import '../Alerts/AlertCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/HomeBloc.dart';
import 'bloc/HomeEvents.dart';
import 'bloc/HomeState.dart';
import 'widgets/CustomPlanWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) =>
          HomeBloc(alertCubit,sessionCubit, provider: TicketProvider())..init(),
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
    final home = BlocProvider.of<HomeBloc>(context);

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorsApp.grey.withOpacity(.9),
        drawer: const DrawerCustom(),
        appBar: customAppBar(
          title: "title_home".tr,
        ),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const Gap(12),
                const Text(
                  "Planes disponibles",
                  style: TextStyle(
                      color: ColorsApp.secondary,
                      fontFamily: 'poppins_bold',
                      fontWeight: FontWeight.w600,
                      fontSize: 26),
                ),
                const Gap(12),
                Visibility(
                  visible: state.load,
                  child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorsApp.green,
                        ),
                      )),
                ),
                Visibility(
                    visible: state.profiles.isNotEmpty && !state.load,
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: state.profiles
                            .where((t) => t.name != "" && t.name != "default")
                            .map((e) => CustomPlanWidget(
                                  profile: e,
                                  generatedUser: (user) {
                                    home.add(
                                        GeneratedTicket(e.name ?? "", user,e.onLogin?.split(",")[3]??""));
                                  },
                                ))
                            .toList(),
                      ),
                    )),
                Visibility(
                    visible: state.profiles.isEmpty && !state.load,
                    child: const Center(
                      child: Text(
                        "Sin Planes disponibles",
                        style: TextStyle(
                            backgroundColor: Colors.transparent,
                            color: ColorsApp.secondary,
                            fontFamily: 'poppins_semi_bold',
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
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
