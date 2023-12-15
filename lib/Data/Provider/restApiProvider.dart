import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../Modules/Alerts/AlertCubit.dart';
import '../../Modules/Session/SessionCubit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..connectionTimeout = const Duration(seconds: 3)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

  }
}

class RestApiProvider {
  static RestApiProvider? _instance;

  factory RestApiProvider() {
    _instance ??= RestApiProvider._();
    return _instance!;
  }

  RestApiProvider._();

  AlertCubit? alertCubit;
  SessionCubit? sessionCubit;

  init(AlertCubit alertCubit, SessionCubit sessionCubit) async {
    this.alertCubit = alertCubit;
    this.sessionCubit = sessionCubit;
  }

  Future<http.Response> get(
      {String url = "", String? user, String? pass, String? host}) async {
    String username = user ?? sessionCubit?.state.cfg?.user ?? "";
    String password = pass ?? sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    try {
      return await http.get(
          Uri.parse('http://${host ?? sessionCubit?.state.cfg?.host}/rest$url'),
          //todo
          headers: {'authorization': basicAuth});
    } catch (e) {
      return http.Response(e.toString(), 500);
    }
  }

  Future<http.Response> post(
      {String url = "default", Map body = const {}}) async {
    String username = sessionCubit?.state.cfg?.user ?? "";
    String password = sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    try {
      final msg = jsonEncode(body);
      return await http.post(
          Uri.parse('http://${sessionCubit?.state.cfg?.host}/rest$url'),
          body: msg,
          headers: {
            'authorization': basicAuth,
            'Content-Type': 'application/json'
          });
    } catch (e) {
      return http.Response(e.toString(), 500);
    }
  }

  Future<http.Response> put(
      {String url = "default", Map body = const {}}) async {
    String username = sessionCubit?.state.cfg?.user ?? "";
    String password = sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    try {
      final msg = jsonEncode(body);
      return await http.put(
          Uri.parse('http://${sessionCubit?.state.cfg?.host}/rest$url'), //todo
          body: msg,
          headers: {
            'authorization': basicAuth,
            'Content-Type': 'application/json'
          });
    } catch (e) {
      return http.Response("error", 500);
    }
  }

  Future<http.Response> delete(
      {String url = "default", Map body = const {}}) async {
    String username = sessionCubit?.state.cfg?.user ?? "";
    String password = sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    final msg = jsonEncode(body);

    try {
      return await http.delete(
          Uri.parse('http://${sessionCubit?.state.cfg?.host}/rest$url'),
          body: msg,
          headers: {
            'authorization': basicAuth,
            'Content-Type': 'application/json'
          });
    } catch (e) {
      return http.Response("error", 500);
    }
  }
}
