// import 'dart:convert';
//
//
// import 'package:http/http.dart' as http;
// import 'package:socket_io_client/socket_io_client.dart';
//
// import '../../Modules/Alerts/AlertCubit.dart';
// import '../../Modules/Session/SessionCubit.dart';
//
// class SocketProvider {
//   static SocketProvider? _instance;
//
//   factory SocketProvider() {
//     _instance ??= SocketProvider._();
//     return _instance!;
//   }
//
//   SocketProvider._();
//
//   AlertCubit? alertCubit;
//   SessionCubit? sessionCubit;
//
//   init(AlertCubit alertCubit, SessionCubit sessionCubit) async {
//     this.alertCubit = alertCubit;
//     this.sessionCubit = sessionCubit;
//   }
//
//   Socket connected(){
//     String username = sessionCubit?.state.cfg?.user ?? "";
//     String password = sessionCubit?.state.cfg?.password ?? "";
//     String basicAuth =
//         'Basic ${base64.encode(utf8.encode('$username:$password'))}';
//
//     var s = io('http://${sessionCubit?.state.cfg?.host}:${sessionCubit?.state.cfg?.port}',
//         OptionBuilder()
//             .setTransports(['websocket']) // for Flutter or Dart VM
//             .disableAutoConnect()  // disable auto-connection
//             .setExtraHeaders({'authorization': basicAuth}) // optional
//             .build()
//     );
//
//     s.connect();
//
//     s.emit("/login");
//     s.emit("=user=$username");
//     s.emit("=password=$password");
//   }
//
//   Future<http.Response> get({String url = "192.168.10.2"}) async {
//
//
//
//     try {
//
//       var s = connected()..connect();
//
//       s.emit(url);
//
//     } catch (e) {
//       return http.Response(e.toString(), 500);
//     }
//   }
//
//   Future<http.Response> post(
//       {String url = "default", Map body = const {}}) async {
//
//     String username = sessionCubit?.state.cfg?.user ?? "";
//     String password = sessionCubit?.state.cfg?.password ?? "";
//     String basicAuth =
//         'Basic ${base64.encode(utf8.encode('$username:$password'))}';
//
//     try {
//       final msg = jsonEncode(body);
//       return await http.post(Uri.parse('https://192.168.10.2/rest$url'),
//           body: msg,
//           headers: {'authorization': basicAuth,
//             'Content-Type': 'application/json'
//           });
//     } catch (e) {
//       return http.Response(e.toString(), 500);
//     }
//   }
//
//   Future<http.Response> put(
//       {String url = "default", Map body = const {}}) async {
//
//     try {
//       return await http.put(Uri.parse('https://api-servidor/v1/$url'), //todo
//           body: body,
//           headers: {});
//     } catch (e) {
//       return http.Response("error", 500);
//     }
//   }
//
//   Future<http.Response> delete(
//       {String url = "default", Map body = const {}}) async {
//
//
//     try {
//       return await http.delete(Uri.parse('https://api-servidor/v1/$url'), //todo
//           body: body,
//           headers: {});
//     } catch (e) {
//       return http.Response("error", 500);
//     }
//   }
// }
