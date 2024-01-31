import 'package:startickera/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main(List<String> args) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}