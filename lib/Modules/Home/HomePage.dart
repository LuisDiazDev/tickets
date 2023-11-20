import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickets/Core/Widgets/custom_text_field.dart';
import 'package:tickets/Modules/Home/bloc/HomeEvents.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../Alerts/AlertCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/HomeBloc.dart';
import 'bloc/HomeState.dart';
import 'widgets/TicketWidget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:aligned_dialog/aligned_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    return BlocProvider(
      create: (context) =>
          HomeBloc(alertCubit, provider: TicketProvider())..init(),
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
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorsApp.grey.withOpacity(.9),
        drawer: DrawerCustom(),
        appBar: AppBar(
          title: const Text("Mis Tickets"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  EvaIcons.menu2Outline,
                  color: ColorsApp.primary,
                  size: 30,
                ),
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
                      Icon(
                        Icons.chevron_right_rounded,
                        color: ColorsApp.primary,
                      )
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
                ...state.tickets
                    .where((t) => t.profile != "" && t.profile != "default")
                    .map((e) => CustomTicketWidget(
                          ticket: e,
                        ))
                    .toList(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: GestureDetector(
          onTap: () {
            showGlobalDrawer(
                context: context,
                builder: horizontalDrawerBuilder(state,homeBloc),
                direction: AxisDirection.right);
          },
          child: Container(
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
        ),
      );
    });
  }

  WidgetBuilder horizontalDrawerBuilder(HomeState state,HomeBloc homeBloc) {
    String profile = "",cant="1";
    final _formKey = GlobalKey<FormState>();

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
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 18, color: Colors.black87),
              child: IntrinsicWidth(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: ColorsApp.secondary.withOpacity(.8),
                          width: double.infinity,
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                "Generar Tickets",
                                style: TextStyle(
                                    color: ColorsApp.primary,
                                    fontFamily: 'poppins_bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Planes disponibles",
                                style: TextStyle(
                                    fontSize: 18, color: ColorsApp.secondary),
                              ),
                              DropdownButtonFormField2<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                                  // the menu padding when button's width is not specified.
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // Add more decoration..
                                ),
                                hint: const Text(
                                  'Selecciona un Plan',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: state.profiles
                                    .where((p) => p.name != "default")
                                    .map((p) => DropdownMenuItem<String>(
                                          value: p.name,
                                          child: Row(
                                            children: [
                                              Text(p.name ?? ""),
                                              Spacer(),
                                              Text(
                                                  "${p.onLogin?.split(",")[4]}\$-${p.onLogin?.split(",")[3]}"),
                                              Icon(
                                                EvaIcons.calendarOutline,
                                                color: ColorsApp.textColor,
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Por favor selecciona un plan';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  //Do something when selected item is changed.
                                },
                                onSaved: (value) {
                                  profile = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomTextField(
                          onChanged: (str) {cant = str ?? "1";},
                          title: "Cantidad",
                          initialValue: cant,
                        ),
                        Spacer(),
                        MaterialButton(
                          height: 80,
                          shape: StadiumBorder(),
                          color: ColorsApp.secondary,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              homeBloc.add(GeneratedTickets(profile, cant));
                            }
                            // Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Generar Tickets',
                            style: TextStyle(
                                color: ColorsApp.primary,
                                fontFamily: "poppins_bold",
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    };
  }
}
