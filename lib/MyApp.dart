import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Core/Routes/Route.dart';
import 'Core/Theme/Theme.dart';
import 'Core/Values/Enums.dart';
import 'Core/Widgets/Snakbar.dart';
import 'Core/localization/app_localization.dart';
import 'Core/utils/navigator_service.dart';
import 'Data/Provider/restApiProvider.dart';
import 'Modules/Alerts/AlertCubit.dart';
import 'Modules/Session/SessionCubit.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AlertCubit>(lazy: false, create: (context) => AlertCubit()),
          BlocProvider<SessionCubit>(create: (context) => SessionCubit()..verifyUser()),
        ],
        child:const MyApp(),
      );
    }

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //Key to show global snackbars
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    final restApiProvider = RestApiProvider();
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    restApiProvider.init(alertCubit,sessionCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Envios',
      onGenerateRoute: routes,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      navigatorKey: NavigatorService.navigatorKey,
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Spanish
      ],
      theme: ThemeApp.themeLight,
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: (context, child) => MultiBlocListener(
        listeners: [
          BlocListener<AlertCubit, AlertState>(
            listener: (context, state) {
              if (state is AlertAction) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBarCustom.snackBarCustom(
                  title: 'title',
                  onTap: () {
                    state.onTap();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  titleAction: 'Action',
                ));
              }
              if (state is AlertInfo) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBarCustom.snackBarStatusCustom(
                  onTap: () {},
                  title: state.title,
                  subtitle: state.subtitle,
                  hideSnackBar: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ));
              }
            },
          ),
          BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) => previous.sessionStatus != current.sessionStatus,
            listener: (context, state) {
              // if(state.fistUse){
              //   _navigator?.pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
              // }else
              // if (state.sessionStatus == SessionStatus.started) {
              //   NavigatorService.pushNamedAndRemoveUntil(Routes.home);
              // }
              // if (state.sessionStatus == SessionStatus.finish) {
              //   NavigatorService.pushNamedAndRemoveUntil(Routes.home);
              // }
            },
          ),
        ],
        child: child!,
      ),
    );
  }
}