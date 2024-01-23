import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:open_settings_plus/android/open_settings_plus_android.dart';
import 'package:open_settings_plus/ios/open_settings_plus_ios.dart';
import 'Core/Theme/Theme.dart';
import 'Core/Values/Enums.dart';
import 'Core/localization/app_localization.dart';
import 'Data/Services/navigator_service.dart';
import 'Data/Services/printer_service.dart';
import 'Data/Provider/restApiProvider.dart';
import 'Modules/Alerts/AlertCubit.dart';
import 'Modules/Session/SessionCubit.dart';
import 'Routes/Route.dart';
import 'Widgets/DialogApp.dart';
import 'Widgets/Snakbar.dart';
import 'Widgets/starlink/card.dart';

class App extends StatelessWidget {
  static const settingsiOS = OpenSettingsPlusIOS();
  static const settingsAndroid = OpenSettingsPlusAndroid();

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlertCubit>(
            lazy: false, create: (context) => AlertCubit()),
        BlocProvider<SessionCubit>(
            create: (context) => SessionCubit()..verify()),
      ],
      child: const MyApp(),
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
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late StreamSubscription subscription;

  @override
  void initState() {
    final restApiProvider = RestApiProvider();
    PrinterService();
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);

    restApiProvider.init(alertCubit, sessionCubit);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result != ConnectivityResult.wifi) {
        alertCubit.showErrorDialog(
            "SIN CONEXIÓN", "No se encuentra conectado a ninguna red wifi",
            onTap: () {
          App.settingsAndroid.wifi();
        },
          titleAction: "ABRIR AJUSTES DE WIFI"
        );
        sessionCubit.changeState(sessionCubit.state.copyWith(wifi: false));
      } else {
        sessionCubit.changeState(sessionCubit.state.copyWith(wifi: true));
      }
    });

    NetworkInfo().getWifiIP().then((w) {
      sessionCubit.changeState(sessionCubit.state.copyWith(ip: w));
    });

    Connectivity().checkConnectivity().then((result) {
      if (result != ConnectivityResult.wifi) {
        alertCubit.showErrorDialog(
            "SIN CONEXIÓN", "No se encuentra conectado a ninguna red wifi",
            onTap: () {
          App.settingsAndroid.wifi();
        },
          titleAction: "ABRIR AJUSTES DE WIFI"
        );
        sessionCubit.changeState(sessionCubit.state.copyWith(wifi: false));
      } else {
        NetworkInfo().getWifiIP().then((w) {
          sessionCubit
              .changeState(sessionCubit.state.copyWith(wifi: true, ip: w));
        });
      }
    });
    super.initState();
  }

  // Be sure to cancel subscription after you are done
  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarTickera',
      onGenerateRoute: routes,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
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
              if (state is ErrorDialogEvent) {
                showDialog(
                    barrierDismissible: false,
                    context:
                        NavigatorService.navigatorKey.currentState!.context,
                    builder: (context) => DialogWidget.dialogInfo(
                          title: state.title,
                          content: state.message,
                          context: NavigatorService
                              .navigatorKey.currentState!.context,
                          onTap: state.onTap,
                          titleAction: state.titleAction??"OK",
                        ));
              }
              if (state is AlertAction) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBarCustom.snackBarCustom(
                  title: 'title',
                  onTap: () {
                    state.onTap();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  titleAction: 'Action',
                  type: CardType.error,
                ));
              }
              if (state is AlertInfo) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBarCustom.snackBarStatusCustom(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  title: state.title,
                  subtitle: state.subtitle,
                  hideSnackBar: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  type: CardType.info,
                ));
              }
            },
          ),
          BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) =>
                previous.sessionStatus != current.sessionStatus,
            listener: (context, state) {
              // if(state.fistUse){
              //   _navigator?.pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
              // }else
              if (state.sessionStatus == SessionStatus.started) {
                NavigatorService.pushNamedAndRemoveUntil(Routes.home);
              }
              if (state.sessionStatus == SessionStatus.finish) {
                NavigatorService.pushNamedAndRemoveUntil(Routes.login);
              }
            },
          ),
        ],
        child: child!,
      ),
    );
  }
}
