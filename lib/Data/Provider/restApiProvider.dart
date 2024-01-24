import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../Modules/Alerts/AlertCubit.dart';
import '../../Modules/Session/SessionCubit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..connectionTimeout = const Duration(milliseconds: 5000)
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

  Future<http.Response> _req(String method,
      {String endpoint = "",
        String? user,
        String? pass,
        String? host,
        Map? body = const {},
        int? timeoutSecs}) async {
    String username = user ?? sessionCubit?.state.cfg?.user ?? "";
    String password = pass ?? sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var uri = Uri.parse('http://${host ?? sessionCubit?.state.cfg?.host}/rest$endpoint');
    var headers = {
      'authorization': basicAuth,
      'Content-Type': 'application/json'
    };
    var timeout = Duration(seconds: timeoutSecs ?? 5);
    try {
      if (method == "get") {
        return await http.get(
          uri,
          headers: headers,
        ).timeout(timeout);
      } else if (method == "post") {
        return await http.post(
          uri,
          body: jsonEncode(body),
          headers: headers,
        ).timeout(timeout);
      } else if (method == "put") {
        return await http.put(
          uri,
          body: jsonEncode(body),
          headers: headers,
        ).timeout(timeout);
      } else if (method == "delete") {
        return await http.delete(
          uri,
          body: jsonEncode(body),
          headers: headers,
        ).timeout(timeout);
      }
      throw Exception("method not found: $method");
    } catch (e) {
      log(e.toString()); // TODO: emit domain error
      return http.Response(e.toString(), 500);
    }
  }

  Future<http.Response> get(
      {String endpoint = "",
      String? user,
      String? pass,
      String? host,
      int? timeoutSecs}) async {
    return _req("get",
        endpoint: endpoint,
        user: user,
        pass: pass,
        host: host,
        timeoutSecs: timeoutSecs);
  }

  Future<http.Response> post(
      {String endpoint = "default", Map body = const {}}) async {
    return _req("post", endpoint: endpoint, body: body);

  }

  Future<http.Response> put(
      {String url = "default", Map body = const {}}) async {
    return _req("put", endpoint: url, body: body);
  }

  Future<http.Response> delete(
      {String url = "default", Map body = const {}}) async {
    return _req("delete", endpoint: url, body: body);
  }
}
