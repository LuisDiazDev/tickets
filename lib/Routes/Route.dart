import 'package:StarTickera/Modules/Login/LoginMK/LoginPage.dart';
import 'package:StarTickera/Modules/Showroom/Showroom.dart';
import 'package:flutter/material.dart';

import '../../Modules/Home/HomePage.dart';
import '../../Modules/MyTickets/MyTickesPage.dart';
import '../../Modules/settings/SettingsPage.dart';
import '../Modules/Initial/Initial.dart';
import '../Modules/Login/LoginFB/LoginPage.dart';
import '../Modules/Profiles/ProfilesPage.dart';
import '../Modules/Reports/ReportPage.dart';

Route Function(RouteSettings) get routes => (RouteSettings settings) {
      Route route;

      switch (settings.name) {
        case Routes.home:
          route = MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: RouteSettings(name: settings.name),
          );
          break;
        case Routes.loginMK:
          route = MaterialPageRoute(
            builder: (_) => const LoginPageMK(),
            settings: RouteSettings(name: settings.name),
          );
          break;
        case Routes.loginFB:
          route = MaterialPageRoute(
            builder: (_) => const LoginPageFB(),
            settings: RouteSettings(name: settings.name),
          );
          break;
        case Routes.settings:
          route = MaterialPageRoute(
            builder: (_) => const SettingsPage(),
            settings: RouteSettings(name: settings.name),
          );
          break;
        case Routes.profiles:
          route = MaterialPageRoute(
            builder: (_) => const ProfilePage(),
            settings: RouteSettings(name: settings.name),
          );
          break;
        case Routes.tickets:
          route = MaterialPageRoute(
              builder: (_) => const TicketsPage(),
              settings: RouteSettings(name: settings.name));
          break;
        case Routes.initial:
          route = MaterialPageRoute(
              builder: (_) => const InitialPage(),
              settings: RouteSettings(name: settings.name));
          break;
        case Routes.showroom:
          route = MaterialPageRoute(
              builder: (_) => const ShowRoomPage(),
              settings: RouteSettings(name: settings.name));
          break;
        case Routes.report:
          route = MaterialPageRoute(
              builder: (_) => const ReportPage(),
              settings: RouteSettings(name: settings.name));
          break;
        default:
          route = MaterialPageRoute(
            builder: (_) => const InitialPage(), //Home page
            settings: RouteSettings(name: settings.name),
          );
          break;
      }

      return route;
    };

abstract class Routes {
  static const loginMK = _Paths.loginMK;
  static const loginFB = _Paths.loginFB;
  static const home = _Paths.home;
  static const initial = _Paths.initial;
  static const settings = _Paths.settings;
  static const profiles = _Paths.profiles;
  static const tickets = _Paths.tickets;
  static const showroom = _Paths.showroom;
  static const report = _Paths.report;
  static const clientList = _Paths.clientList;
  static const clientProfile = _Paths.clientProfile;
}

abstract class _Paths {
  static const loginMK = '/loginMK';
  static const loginFB = '/loginFB';
  static const home = '/home';
  static const initial = '/initial';
  static const settings = '/settings';
  static const profiles = '/profiles';
  static const tickets = '/tickets';
  static const showroom = '/showroom';
  static const report = '/report';
  static const clientList = '/client_list';
  static const clientProfile = '/client_profile';
}
