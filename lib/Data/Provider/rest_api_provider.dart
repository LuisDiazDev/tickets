import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RestApiProvider {
  Future<http.Response> sendRequest(
    String method, {
    required String endpoint,
    required String user,
    required String pass,
    required String host,
    Map? body = const {},
    int? timeoutSecs,
    int attempt = 1,
  }) async {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$user:$pass'))}';
    var uri = Uri.parse('http://$host:80/rest$endpoint');
    var headers = {
      'authorization': basicAuth,
      'Content-Type': 'application/json'
    };
    var timeout = Duration(seconds: timeoutSecs ?? 5);
    late http.Response response;
    try {
      if (method == "get") {
        response = await http
            .get(
              uri,
              headers: headers,
            )
            .timeout(timeout);
      } else if (method == "post") {
        response = await http
            .post(
              uri,
              body: jsonEncode(body),
              headers: headers,
            )
            .timeout(timeout);
      } else if (method == "put") {
        response = await http
            .put(
              uri,
              body: jsonEncode(body),
              headers: headers,
            )
            .timeout(timeout);
      } else if (method == "delete") {
        response = await http
            .delete(
              uri,
              body: jsonEncode(body),
              headers: headers,
            )
            .timeout(timeout);
      }
    } catch (e) {
      log(e.toString()); // TODO: emit domain error
      if (response.statusCode > 205) {
        if (response.body.isNotEmpty &&
            response.body.toString().contains("Connection reset by peer")) {
          if (attempt > 3) {
            return response;
          }
          return sendRequest(
            method,
            endpoint: endpoint,
            user: user,
            pass: pass,
            host: host,
            body: body,
            timeoutSecs: timeoutSecs,
            attempt: attempt + 1,
          );
        }
      }
      return http.Response(e.toString(), 500);
    }

    return response;
  }
  //
  // Future<http.Response> get({
  //   required String endpoint,
  //   required String user,
  //   required String pass,
  //   required String host,
  //   int? timeoutSecs,
  // }) async {
  //   return sendRequest("get",
  //       endpoint: endpoint,
  //       user: user,
  //       pass: pass,
  //       host: host,
  //       timeoutSecs: timeoutSecs);
  // }
  //
  // Future<http.Response> post(
  //     {
  //       String endpoint = "default",
  //       Map body = const {},
  //       required String user,
  //       required String pass,
  //       required String host,
  //     }) async {
  //   return sendRequest("post",
  //       endpoint: endpoint,
  //       body: body,
  //       user: user,
  //       pass: pass,
  //       host: host
  //   );
  // }
  //
  // Future<http.Response> put(
  //     {
  //       String endpoint = "default",
  //       Map body = const {},
  //       required String user,
  //       required String pass,
  //       required String host,
  //     }) async {
  //   return sendRequest(
  //       "put",
  //       endpoint: endpoint,
  //       body: body,
  //       user: user,
  //       pass: pass,
  //       host: host
  //   );
  // }
  //
  // Future<http.Response> delete(
  //     {
  //       String endpoint = "default",
  //       Map body = const {},
  //       required String user,
  //       required String pass,
  //       required String host,
  //     }) async {
  //   return sendRequest(
  //       "delete",
  //       endpoint: endpoint,
  //       body: body,
  //       user: user,
  //       pass: pass,
  //       host: host,
  //   );
  // }
}
