import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../Modules/Alerts/AlertCubit.dart';
import '../../Modules/Session/SessionCubit.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class RestApiProvider {
  static RestApiProvider? _instance;
  bool dev = false;

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

  Future<http.Response> get({String url = "192.168.10.2"}) async {
    String username = sessionCubit?.state.cfg?.user ?? "";
    String password = sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    if (dev) {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response("", 200);
    }

    try {
      return await http.get(Uri.parse('https://${sessionCubit?.state.cfg?.host}/rest$url'), //todo
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

    if (dev) {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response("", 200);
    }

    try {
      return await http.post(Uri.parse('https://192.168.10.2/rest/$url'), //todo
          body: body,
          headers: {'authorization': basicAuth});
    } catch (e) {
      return http.Response("error", 500);
    }
  }

  Future<http.Response> put(
      {String url = "default", Map body = const {}}) async {
    if (dev) {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response("", 200);
    }

    try {
      return await http.put(Uri.parse('https://api-servidor/v1/$url'), //todo
          body: body,
          headers: {});
    } catch (e) {
      return http.Response("error", 500);
    }
  }

  Future<http.Response> delete(
      {String url = "default", Map body = const {}}) async {
    if (dev) {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response("", 200);
    }

    try {
      return await http.delete(Uri.parse('https://api-servidor/v1/$url'), //todo
          body: body,
          headers: {});
    } catch (e) {
      return http.Response("error", 500);
    }
  }
}
