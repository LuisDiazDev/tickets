import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:open_settings_plus/android/open_settings_plus_android.dart';
import 'package:open_settings_plus/ios/open_settings_plus_ios.dart';
import 'Core/Theme/theme.dart';
import 'Core/Values/enums.dart';
import 'Core/localization/app_localization.dart';
import 'Data/Services/navigator_service.dart';
import 'Data/database/databse_firebase.dart';
import 'Modules/Alerts/alert_cubit.dart';
import 'Modules/Session/session_cubit.dart';
import 'Routes/route.dart';
import 'Widgets/starlink/colors.dart';
import 'Widgets/starlink/dialog.dart';
import 'Widgets/starlink/text_style.dart';

class App extends StatelessWidget {
  static const settingsiOS = OpenSettingsPlusIOS();
  static const settingsAndroid = OpenSettingsPlusAndroid();

  const App({super.key});

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

    final alertCubit = BlocProvider.of<AlertCubit>(context);
    final sessionCubit = BlocProvider.of<SessionCubit>(context);

    DatabaseFirebase().init(alertCubit, sessionCubit);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result != ConnectivityResult.wifi) {
        alertCubit.showDialog(
          ShowDialogEvent(
              title: "SIN CONEXIÓN",
              message: "No se encuentra conectado a ninguna red wifi",
              type: AlertType.error,
              onTap: () {
                App.settingsAndroid.wifi();
              },
              actions: [
                TextButton(
                  onPressed: () {
                    App.settingsAndroid.wifi();
                  },
                  child: StarlinkText("ABRIR AJUSTES DE WIFI", color: StarlinkColors.white,),
                ),
              ]),
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
        alertCubit.showDialog(
          ShowDialogEvent(
              title: "SIN CONEXIÓN",
              message: "No se encuentra conectado a ninguna red wifi",
              type: AlertType.error,
              onTap: () {
                App.settingsAndroid.wifi();
              },
              actions: [
                TextButton(
                  onPressed: () {
                    App.settingsAndroid.wifi();
                  },
                  child: StarlinkText("ABRIR AJUSTES DE WIFI"),
                ),
              ]),
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
              if (state is ShowDialogEvent) {
                StarlinkDialog.show(
                  context: NavigatorService.navigatorKey.currentState!.context,
                  title: state.title,
                  message: state.message,
                  type: state.type,
                  onTap: () {
                    if (state.onTap != null) {
                      state.onTap!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  actions: state.actions,
                  error: state.error,
                  metadata: state.metadata,
                );
              }
            },
          ),
          BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) => previous.sessionStatus != current.sessionStatus,
            listener: (context, state) {
              if (state.sessionStatus == SessionStatus.started) {
                NavigatorService.pushNamedAndRemoveUntil(Routes.home);
              }
              if (state.sessionStatus == SessionStatus.finish) {
                NavigatorService.pushNamedAndRemoveUntil(Routes.loginFB);
              }
              if (state.sessionStatus == SessionStatus.mikrotik) {
                NavigatorService.pushNamedAndRemoveUntil(Routes.loginMK);
              }
            },
          ),
        ],
        child: child!,
      ),
    );
  }
}
