

import 'package:StarTickera/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main(List<String> args) async {

  print(args);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


}