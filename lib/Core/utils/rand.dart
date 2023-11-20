
import 'dart:math';

String generateUser() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  int passLength = 4;
  String seed = upper + lower + numbers;
  String user = '';
  List<String> list = seed.split('').toList();
  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    user += list[index];
  }
  return user;
}