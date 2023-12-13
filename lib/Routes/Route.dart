import 'package:flutter/material.dart';
import 'package:tickets/Modules/Profiles/ProfilesPage.dart';

import '../../Modules/Home/HomePage.dart';
import '../../Modules/MyTickets/MyTickesPage.dart';
import '../../Modules/settings/SettingsPage.dart';




Route Function(RouteSettings) get routes => (RouteSettings settings) {
  Route route;

  switch (settings.name) {
    case Routes.home:
      route = MaterialPageRoute(
        builder: (_) => const HomePage(),
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
        settings: RouteSettings(name: settings.name)
      );
      break;
    default:
      route = MaterialPageRoute(
        builder: (_) => const HomePage(),//Home page
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
}

abstract class _Paths {
  static const login = '/login';
  static const home = '/home';
  static const initial = '/initial';
  static const settings = '/settings';
  static const profiles = '/profiles';
  static const tickets = '/tickets';
}