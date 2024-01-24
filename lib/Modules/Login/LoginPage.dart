import 'package:StarTickera/Modules/Login/widget/find_ip_widget.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Services/navigator_service.dart';
import '../../Routes/Route.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/text_style.dart';
import '../Alerts/AlertCubit.dart';
import '../Session/SessionCubit.dart';
import 'bloc/LoginBloc.dart';
import 'bloc/LoginEvents.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    return BlocProvider(
      create: (context) => LoginBloc(alertCubit, sessionCubit),
      child: const _BuildLoginPage(),
    );
  }
}

class _BuildLoginPage extends StatefulWidget {
  const _BuildLoginPage({Key? key}) : super(key: key);

  @override
  State<_BuildLoginPage> createState() => _BuildLoginPageState();
}

class _BuildLoginPageState extends State<_BuildLoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _viewShowRoomCounter = 0;
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: StarlinkColors.black,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTitle(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                    ),
                    StarlinkText(
                      'INICIAR SESIÓN',
                      size: 32,
                      // color: ,
                    ),
                    const SizedBox(width: double.infinity, height: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StarlinkTextField(
                          // suffixIcon: state.host.value != "" ? state.host.isValid ? const Icon(Icons.check,color: Colors.green,) : const Icon(Icons.error,color: Colors.red,) : null,
                          onChanged: (h) {
                            loginBloc.add(ChangeHost(h));
                          },
                          initialValue: loginBloc.state.host.value == "" ? loginBloc.state.initialHost : loginBloc.state.host.value,
                          title: 'IP DEL MIKROTIK',
                          textHint: 'IP DEL MIKROTIK',
                          keyboardType: TextInputType.number,
                          maxLength: 14,
                          validator: validateIP,
                        ),
                        StarlinkButton(
                            text: "BUSCAR UN MIKROTIK EN LA RED",
                            type: ButtonType.secondary,
                            onPressed: () async {
                              var fhost = await IpSearch().showDialogSearch();
                              if (fhost != null) {
                                setState(() {
                                  loginBloc.add(ChangeHost(fhost.ipv4??""));
                                });
                              }
                            }),
                      ],
                    ),
                    StarlinkTextField(
                      onChanged: (currentUser) {
                        loginBloc.add(ChangeUser(currentUser));
                      },
                      validator: (value) {
                        if (value == "") {
                          return "Ingrese un usuario";
                        }
                        return null;
                      },
                      initialValue: loginBloc.state.user.value,
                      title: 'USUARIO',
                      textHint: 'USUARIO DEL MIKROTIK',
                    ),
                    StarlinkTextField(
                      onChanged: (currentPassword) {
                        loginBloc.add(ChangePassword(currentPassword));
                      },
                      validator: (value) {
                        if (value == "") {
                          return "Ingrese una contraseña";
                        }
                        return null;
                      },
                      initialValue: loginBloc.state.password.value,
                      title: 'CONTRASEÑA',
                      textHint: 'CONTRASEÑA DEL MIKROTIK',
                    ),
                    StarlinkButton(
                        text: "INICIAR SESIÓN",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            loginBloc.add(LogIn(
                              loginBloc.state.user.value,
                              loginBloc.state.host.value,
                              loginBloc.state.password.value,
                            ));
                          }

                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  String? validateIP(value) {
                        if (value == "") {
                          return "Ingrese una IP";
                        }
                        if (value!.length < 7) {
                          return "Ingrese una IP válida";
                        }
                        var sp = value.split(".");
                        if (sp.length != 4) {
                          return "Ingrese una IP válida (4 octetos)";
                        }
                        for (var i = 0; i < sp.length; i++) {
                          var octeto = sp[i];
                          if (octeto == "") {
                            return "Ingrese una IP válida (octeto vacío)";
                          }
                          if (int.tryParse(octeto) == null) {
                            return "Ingrese una IP válida (octeto no numérico)";
                          }
                          if (int.parse(octeto) > 255) {
                            return "Ingrese una IP válida (octeto mayor a 255)";
                          }
                        }
                        return null;
                      }

  GestureDetector buildTitle() {
    return GestureDetector(
                    onTap: () {
                      // show the
                      _viewShowRoomCounter++;
                      if (_viewShowRoomCounter == 10) {
                        NavigatorService.pushNamedAndRemoveUntil(
                            Routes.showroom);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: StarlinkText(
                        'STARTICKERA',
                        size: 16,
                        extraSeparation: true,
                        // color: ,
                      ),
                    ),
                  );
  }
}
