import 'package:StarTickera/Modules/Reports/widgets/LineChart.dart';
import 'package:StarTickera/Modules/Reports/widgets/UserActive/ActiveUsersWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/colors.dart';
import '../Alerts/AlertCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/ReportBloc.dart';
import 'bloc/ReportState.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    return BlocProvider(
      create: (context) =>
          ReportBloc(alertCubit, provider: MkProvider())..init(),
      child: const _BuildReportPage(),
    );
  }
}

class _BuildReportPage extends StatefulWidget {
  const _BuildReportPage();

  @override
  State<_BuildReportPage> createState() => _BuildReportPageState();
}

class _BuildReportPageState extends State<_BuildReportPage> {

  @override
  Widget build(BuildContext context) {
    final reportBloc = BlocProvider.of<ReportBloc>(context);

    return BlocBuilder<ReportBloc, ReportState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: StarlinkColors.black,
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "Reporte"),
        body: Container(
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const CustomLineChart(isShowingMainData: true,),
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
                        "Total de Ventas de hoy",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: StarlinkColors.black,
                          fontFamily: 'DDIN-Bold',
                        ),
                      ),
                      subtitle:state.load ? const CircularProgressIndicator() : Text(
                        "${reportBloc.getTotal()}\$",
                        style: const TextStyle(
                            color: StarlinkColors.black,
                            fontFamily: 'DDIN',
                            fontSize: 22
                        ),
                      ),
                    ),
                  )
              ),
              const ActiveTicketsWidget(),
            ],
          ),
        ),
      );
    });
  }
}
