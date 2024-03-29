// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC7VaYkZtKUJcd32-FsEODQu2Yymo9sgbA',
    appId: '1:972275994200:web:672e345e2c810311d5042d',
    messagingSenderId: '972275994200',
    projectId: 'startickera',
    authDomain: 'startickera.firebaseapp.com',
    storageBucket: 'startickera.appspot.com',
    measurementId: 'G-P0KHJR48SJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDF-sd5GmbOOC0WD2unM6Z4iujQcKZDUpM',
    appId: '1:972275994200:android:65f297d9aaa0b78dd5042d',
    messagingSenderId: '972275994200',
    projectId: 'startickera',
    storageBucket: 'startickera.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDC2Jq_Fm4MKvc9-8FiIk3kkeEKRNLLrFQ',
    appId: '1:972275994200:ios:9450a6e977b076b7d5042d',
    messagingSenderId: '972275994200',
    projectId: 'startickera',
    storageBucket: 'startickera.appspot.com',
    iosBundleId: 'com.example.tickets',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDC2Jq_Fm4MKvc9-8FiIk3kkeEKRNLLrFQ',
    appId: '1:972275994200:ios:ab6a694bc4df0af4d5042d',
    messagingSenderId: '972275994200',
    projectId: 'startickera',
    storageBucket: 'startickera.appspot.com',
    iosBundleId: 'com.example.tickets.RunnerTests',
  );
}
