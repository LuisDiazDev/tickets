import 'package:StarTickera/Modules/Login/widget/find_ip_widget.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../Core/Values/Colors.dart';
import '../../Data/Services/navigator_service.dart';
import '../../Routes/Route.dart';
import '../../Widgets/starlink/text_style.dart';
import '../Alerts/AlertCubit.dart';
import '../Session/SessionCubit.dart';
import 'bloc/LoginBloc.dart';
import 'bloc/LoginEvents.dart';
import 'bloc/LoginState.dart';
import 'widget/customs_texts_fields.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
  String email = "";
  int _viewShowRoomCounter = 0;
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: StarlinkColors.black,
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // show the
                      _viewShowRoomCounter++;
                      if (_viewShowRoomCounter == 10) {
                        NavigatorService.pushNamedAndRemoveUntil(Routes.showroom);
                      }
                    },
                    child: StarlinkText(
                      'STARTICKERA',
                      size: 16,
                      // color: ,
                    ),
                  ),
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
                            initialValue: state.initialHost,
                            title: 'IP DEL MIKROTIK',
                            textHint: 'IP DEL MIKROTIK',
                            keyboardType: TextInputType.number,
                            maxLength: 14,
                          ),
                          StarlinkButton(
                              text: "BUSCAR UN MIKROTIK EN LA RED",
                              type: ButtonType.secondary,
                              onPressed: () async {
                                var host = await IpSearch.showDialogSearch();
                                loginBloc.add(ChangeInitialHost(host));
                              }),
                        ],
                      ),
                      StarlinkTextField(
                        onChanged: (email) {
                          loginBloc.add(ChangeEmail(email));
                        },
                        initialValue: "admin",
                        title: 'USUARIO',
                        textHint: 'USUARIO DEL MIKROTIK',
                      ),
                      StarlinkTextField(
                        onChanged: (password) {
                          loginBloc.add(ChangePassword(password));
                        },
                        initialValue: "",
                        title: 'CONTRASEÑA',
                        textHint: 'CONTRASEÑA DEL MIKROTIK',
                      ),
                      StarlinkButton(text: "INICIAR SESIÓN", onPressed: () {
                        loginBloc.add(LogIn(
                          state.email.value,
                          state.host.value,
                          state.password.value,
                        ));
                      }),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
