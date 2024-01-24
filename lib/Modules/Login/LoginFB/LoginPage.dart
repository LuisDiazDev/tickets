import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Routes/Route.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../Alerts/AlertCubit.dart';
import '../../Session/SessionCubit.dart';
import 'bloc/LoginBloc.dart';
import 'bloc/LoginEvents.dart';

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
                        'INICIAR SESIÓN APP',
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
                        initialValue: loginBloc.state.user.value,
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
                        initialValue: loginBloc.state.password.value,
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
