import 'package:StarTickera/Modules/Showroom/Showroom.dart';
import 'package:flutter/material.dart';

import '../../Modules/Home/HomePage.dart';
import '../../Modules/MyTickets/MyTickesPage.dart';
import '../../Modules/settings/SettingsPage.dart';
import '../Modules/Clients/client_list.dart';
import '../Modules/Clients/client_profiles.dart';
import '../Modules/Initial/Initial.dart';
import '../Modules/Login/LoginPage.dart';
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
        case Routes.login:
          route = MaterialPageRoute(
            builder: (_) => const LoginPage(),
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
        case Routes.clientList:
          route = MaterialPageRoute(
              builder: (_) => const ListClientPage(),
              settings: RouteSettings(name: settings.name));
          break;
        case Routes.clientProfile:
          route = MaterialPageRoute(
              builder: (_) => const ClientsProfilePage(),
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
  static const login = _Paths.login;
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
  static const login = '/login';
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
