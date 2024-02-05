import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..connectionTimeout = const Duration(milliseconds: 5000)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
