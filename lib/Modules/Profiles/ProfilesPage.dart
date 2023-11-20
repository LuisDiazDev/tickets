import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../Alerts/AlertCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/ProfileBloc.dart';
import 'bloc/ProfileState.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

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
    // final ruteBloc = BlocProvider.of<MyRuteBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorsApp.grey.withOpacity(.9),
        drawer: DrawerCustom(),
        appBar: AppBar(
          title: const Text("Mis Planes"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(EvaIcons.menu2Outline,color: ColorsApp.primary,size: 30,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 30),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SettingWidget(),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ordenar por',
                        style: TextStyle(
                          color: ColorsApp.primary,
                          fontSize: 18,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,color: ColorsApp.primary,)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Wrap(
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
                ...state.profiles.where((p) => p.name!="default").map((e) => Card(
                  child: ListTile(
                    leading: Icon(EvaIcons.calendarOutline,size: 36,color: ColorsApp.secondary,),
                    title: Text(e.name ?? ""),
                    subtitle: RichText(text: TextSpan(text: "Precio: ",style: TextStyle(fontFamily: "poppins_semi_bold",fontWeight: FontWeight.w400, fontSize: 18,color:ColorsApp.textColor),children: [
                      TextSpan(text: "${e.onLogin?.split(",")[4] ?? ""} \$",style: TextStyle(fontFamily: "poppins_bold",fontWeight: FontWeight.w500, fontSize: 20,color: ColorsApp.secondary))
                    ]),
                    ),
                    trailing: Text("${e.onLogin?.split(",")[3] ?? ""}",style: TextStyle(fontFamily: "poppins_bold",fontWeight: FontWeight.w500, fontSize: 20,color: ColorsApp.secondary)),
                  ),
                ))
                    .toList(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
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
      );
    });
  }
}
