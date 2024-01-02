
import 'dart:math';

String generatePassword() {
  String upper = 'ABCDEFGHKMNPQRSTXYZ';
  String numbers = '23456789';
  int passLength = 5;
  String seed = upper + numbers;
  String user = '';
  List<String> list = seed.split('').toList();
  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    user += list[index];
  }
  return user;
}