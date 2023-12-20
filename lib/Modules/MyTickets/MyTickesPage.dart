import 'package:TicketOs/Core/localization/app_localization.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/custom_text_field.dart';
import '../../models/profile_model.dart';
import '../Alerts/AlertCubit.dart';
import '../drawer/drawer.dart';
import 'bloc/TicketsBloc.dart';
import 'bloc/TicketsEvents.dart';
import 'bloc/TicketsState.dart';
import 'widgets/TicketWidget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:aligned_dialog/aligned_dialog.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    return BlocProvider(
      create: (context) =>
          TicketsBloc(alertCubit, provider: TicketProvider())..init(),
      child: const _BuildTicketsPage(),
    );
  }
}

class _BuildTicketsPage extends StatefulWidget {
  const _BuildTicketsPage({Key? key}) : super(key: key);

  @override
  State<_BuildTicketsPage> createState() => _BuildTicketsPageState();
}

class _BuildTicketsPageState extends State<_BuildTicketsPage>
    with AutomaticKeepAliveClientMixin<_BuildTicketsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<TicketsBloc>(context);
    super.build(context);
    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "title_list_tickets".tr),
        body: Stack(
          children: [
            Visibility(
              visible: state.load,
              child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * .85,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: ColorsApp.green,
                    ),
                  )),
            ),
            Visibility(
              visible: state.tickets.isNotEmpty && !state.load,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Builder(builder: (context) {
                    var tickets = state.tickets.where((t) =>
                        t.profile != "" &&
                        t.profile != "default" &&
                        !t.name!.contains("-"));
                    if (tickets.isEmpty) {
                      return Center(
                        child: MaterialButton(
                          onPressed: () {
                            showGlobalDrawer(
                                context: context,
                                builder:
                                    horizontalDrawerBuilder(state, homeBloc),
                                direction: AxisDirection.right);
                          },
                          child: Text("Crear Nuevo Ticket"),
                        ),
                      );
                    }
                    return Wrap(
                      children: [
                        ...tickets
                            .map((e) => Builder(
                              builder: (context) {
                                var profile = state.profiles
                                    .firstWhere((p) => p.name == e.profile, orElse: () => ProfileModel(name: "", onLogin: ""));
                                return CustomTicketWidget(
                                      ticket: e,
                                      profile: profile,
                                    );
                              }
                            ))
                            .toList(),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Visibility(
                visible: state.tickets.isEmpty && !state.load,
                child: Center(
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text("Crear Nuevo Ticket"),
                  ),
                ))
          ],
        ),
        bottomSheet: Visibility(
          visible: state.tickets.isNotEmpty,
          child: GestureDetector(
            onTap: () {
              showGlobalDrawer(
                  context: context,
                  builder: horizontalDrawerBuilder(state, homeBloc),
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
        ),
      );
    });
  }

  WidgetBuilder horizontalDrawerBuilder(
      TicketsState state, TicketsBloc homeBloc) {
    String cant = "1";
    ProfileModel? current;

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
                              DropdownButtonFormField2<ProfileModel>(
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
                                    .map((p) => DropdownMenuItem<ProfileModel>(
                                          value: p,
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
                                  current = value;
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
                          onChanged: (str) {
                            cant = str ?? "1";
                          },
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
                              homeBloc.add(GeneratedTickets(current?.name ?? "",
                                  cant, current?.onLogin?.split(",")[3] ?? ""));
                            }
                            Navigator.of(context).pop();
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
