import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../Modules/Alerts/alert_cubit.dart';
import '../../Modules/Session/session_cubit.dart';

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
        int? timeoutSecs,
        int attempt=1
      }) async {
    String username = user ?? sessionCubit?.state.cfg?.user ?? "";
    String password = pass ?? sessionCubit?.state.cfg?.password ?? "";
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var uri = Uri.parse('http://${host ?? sessionCubit?.state.cfg?.host}:80/rest$endpoint');
    var headers = {
      'authorization': basicAuth,
      'Content-Type': 'application/json'
    };
    var timeout = Duration(seconds: timeoutSecs ?? 5);
    late http.Response response;
    try {
      if (method == "get") {
        response = await http.get(
          uri,
          headers: headers,
        ).timeout(timeout);
      } else if (method == "post") {
        response = await http.post(
          uri,
          body: jsonEncode(body),
          headers: headers,
        ).timeout(timeout);
      } else if (method == "put") {
        response = await http.put(
          uri,
          body: jsonEncode(body),
          headers: headers,
        ).timeout(timeout);
      } else if (method == "delete") {
        response = await http.delete(
          uri,
          body: jsonEncode(body),
          headers: headers,
        ).timeout(timeout);
      }
    } catch (e) {
      log(e.toString()); // TODO: emit domain error
      if (response.statusCode > 205) {
        if (response.body.isNotEmpty && response.body.toString().contains("Connection reset by peer")) {
          if (attempt > 3) {
            return response;
          }
          return _req(method, endpoint: endpoint, user: user, pass: pass, host: host, body: body, timeoutSecs: timeoutSecs, attempt: attempt+1);
        }
      }
      return http.Response(e.toString(), 500);
    }

    return response;
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
