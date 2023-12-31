import 'package:TicketOs/Modules/Login/widget/find_ip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../Core/Values/Colors.dart';
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
      create: (context) => LoginBloc(
        alertCubit,
        sessionCubit
      ),
      child: const _BuildLoginPage(),
    );
  }
}

class _BuildLoginPage extends StatefulWidget {
  const _BuildLoginPage({Key? key}) : super(key: key);

  @override
  State<_BuildLoginPage> createState() => _BuildLoginPageState();
}

class _BuildLoginPageState extends State<_BuildLoginPage> with TickerProviderStateMixin {

  String email = "";


  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
       return SafeArea(
        child:Scaffold(
          backgroundColor: ColorsApp.primary,
          body: BlocBuilder<LoginBloc,LoginState>(
            builder: (context,state){
              return SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     SizedBox(
                       height: MediaQuery.of(context).size.height*.2,
                     ),
                     const Text(
                        'TicketOs',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF123258),
                          fontSize: 32,
                          fontFamily: 'Domine',
                          fontWeight: FontWeight.w700,
                          height: 1.30,
                        ),
                      ),
                      const SizedBox(width: double.infinity,height: 25),
                      const Text(
                        'Introduce las credenciales del mikrotik',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF4B667F),
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.70,
                        ),
                      ),
                      const SizedBox(width: double.infinity,height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: CustomsTextFields(
                              hintText: 'Ip mikrotik',
                              initial: state.initialHost,
                              suffixIcon: state.host.value != "" ? state.host.isValid ? const Icon(Icons.check,color: Colors.green,) : const Icon(Icons.error,color: Colors.red,) : null,
                              onChange: (host){
                                loginBloc.add(ChangeHost(host));
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              var ip = await NetworkInfo().getWifiIP();
                              var host = await IpSearch.showDialogSearch(ip:ip??"...");
                              loginBloc.add(ChangeInitialHost(host));
                              // setState(() {
                              //
                              // });
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              decoration: const BoxDecoration(color: Color(0xFF123258)),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Buscar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 1.70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 350,
                        child: CustomsTextFields(
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'usuario',
                          suffixIcon: state.email.value != "" ? const Icon(Icons.check,color: Colors.green,) : const Icon(Icons.error,color: Colors.red,),
                          onChange: (email){
                            loginBloc.add(ChangeEmail(email));
                          },
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: CustomsTextFields(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Contraseña',
                          obscureText: false,
                          onChange: (password){
                            loginBloc.add(ChangePassword(password));
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          loginBloc.add(LogIn(
                            state.email.value,
                            state.host.value,
                            state.password.value,
                          ));
                        },
                        child: Container(
                          width: 335,
                          height: 50,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: const BoxDecoration(color: Color(0xFF123258)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Continuar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 1.70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}


