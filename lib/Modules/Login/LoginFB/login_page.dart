import 'package:startickera/Widgets/starlink/button.dart';
import 'package:startickera/Widgets/starlink/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../Alerts/alert_cubit.dart';
import '../../Session/session_cubit.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_events.dart';

class LoginPageFB extends StatelessWidget {
  const LoginPageFB({super.key});

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
  const _BuildLoginPage();

  @override
  State<_BuildLoginPage> createState() => _BuildLoginPageState();
}

class _BuildLoginPageState extends State<_BuildLoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                        keyboardType: TextInputType.emailAddress,
                        initialValue: loginBloc.state.user.value, // TODO descomentar
                        // initialValue: "dahu34@gmail.com",
                        title: 'USUARIO',
                        textHint: 'Usuario de la app',
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
                        obscureText: true,
                        initialValue: loginBloc.state.password.value, // TODO descomentar
                        // initialValue: "123456",
                        title: 'CONTRASEÑA',
                        textHint: 'Contraseña de la app',
                      ),
                      StarlinkButton(
                          text: "INICIAR SESIÓN",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginBloc.add(LogIn(
                                loginBloc.state.user.value,
                                loginBloc.state.password.value,
                                // "dahu34@gmail.com",
                                // "123456",
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
      ),
    ));
  }

  GestureDetector buildTitle() {
    return GestureDetector(
                    onTap: () {
                      // show the
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
