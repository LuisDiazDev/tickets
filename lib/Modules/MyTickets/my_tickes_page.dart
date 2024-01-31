import 'package:startickera/Widgets/starlink/text_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../Core/Values/colors.dart';
import '../../../Data/Provider/mk_provider.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/starlink/colors.dart';
import '../../models/profile_model.dart';
import '../../models/ticket_model.dart';
import '../Alerts/alert_cubit.dart';
import '../drawer/drawer.dart';
import 'bloc/tickets_bloc.dart';
import 'bloc/tickets_events.dart';
import 'bloc/tickets_state.dart';
import 'widgets/ticket_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    return BlocProvider(
      create: (context) =>
          TicketsBloc(alertCubit, provider: MkProvider())..init(),
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
        appBar: customAppBar(title: "TICKETS CREADOS"),
        body: Column(
          children: [
            if (!state.load && tickets.isEmpty)
              Center(
                child: Column(
                  children: [
                    const Gap(100),
                    StarlinkText(
                    "No hay tickets creados",
                    size: 18,
                    isBold: true,
                  )],
                ),
            ),
            if (!state.load && profiles.isEmpty)
              Center(
                child: StarlinkText(
                  "Debes crear un plan primero",
                  size: 18,
                  isBold: true,
                ),
              ),
            Visibility(
              visible: tickets.isNotEmpty && !state.load,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Builder(builder: (context) {
                    return Wrap(
                      children: [
                        ...tickets.map((e) => Builder(builder: (context) {
                              var profile = state.profiles.firstWhere(
                                  (p) => p.name == e.profile,
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
              ),
            ),
          ],
        ),
      );
    });
  }

  WidgetBuilder horizontalDrawerBuilder(
      TicketsState state, TicketsBloc homeBloc) {
    String cant = "1";
    ProfileModel? currentProfile;

    final formKey = GlobalKey<FormState>();

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
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              child: IntrinsicWidth(
                child: Form(
                    key: formKey,
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
                                    fontFamily: 'DDIN',
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
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StarlinkText(
                                "Planes disponibles",
                                size: 18,
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
                                hint: StarlinkText(
                                  'Selecciona un Plan',
                                  size: 18,
                                ),
                                items: state.profiles
                                    .where((p) => p.name != "default")
                                    .map((p) => DropdownMenuItem<ProfileModel>(
                                          value: p,
                                          child: Row(
                                            children: [
                                              StarlinkText(p.name ?? ""),
                                              const Spacer(),
                                              StarlinkText(
                                                  // "${p.onLogin?.split(",")[4]}\$-${p.onLogin?.split(",")[3]}"),
                                                  "${p.metadata?.price.toString()}\$-${p.metadata?.usageTime}"),
                                              const Icon(
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
                                  currentProfile = value;
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
                        const Spacer(),
                        MaterialButton(
                          height: 80,
                          shape: const StadiumBorder(),
                          color: ColorsApp.secondary,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              // String duration = currentProfile?.onLogin?.split(",")[3] ?? "";
                              String duration =
                                  currentProfile?.metadata?.usageTime ?? "";
                              homeBloc.add(GenerateTicket(
                                  currentProfile?.name ?? "", cant, duration));
                            }
                            Navigator.of(context).pop();
                          },
                          child: StarlinkText(
                            'Generar Tickets',
                            size: 18,
                          ),
                        ),
                        const SizedBox(
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
