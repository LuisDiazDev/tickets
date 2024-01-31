import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import '../../Modules/Alerts/alert_cubit.dart';
import '../../Modules/Session/session_cubit.dart';

class DatabaseFirebase {
  static DatabaseFirebase? _instance;
  factory DatabaseFirebase() {
    _instance ??= DatabaseFirebase._();
    return _instance!;
  }

  DatabaseFirebase._();

  AlertCubit? alertCubit;
  SessionCubit? sessionCubit;

  init(AlertCubit alertCubit, SessionCubit sessionCubit) async {
    this.alertCubit = alertCubit;
    this.sessionCubit = sessionCubit;
  }

  Future<bool> checkUUID()async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/${sessionCubit?.state.firebaseID}').get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    }catch (e){
      return false;
    }
  }

  Future getLicense()async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/${sessionCubit?.state.firebaseID}').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return null;
    }
  }

  Future<bool> updateLicense(String license)async{
    try{
      await FirebaseDatabase.instance
          .ref('users/${sessionCubit?.state.firebaseID}/license')
          .set(license);
      return true;
    }catch (e){
      return false;
    }
  }

  Future<bool> updateName(String name)async{
    try{
      await FirebaseDatabase.instance
          .ref('users/${sessionCubit?.state.firebaseID}/name')
          .set(name);
      return true;
    }catch (e){
      return false;
    }
  }

  Future getName()async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/${sessionCubit?.state.firebaseID}/name').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return null;
    }
  }

  Future<bool> updateSeller(String name,String price,String duration,String profile)async{
    List sellers = [];

    try{
      sellers.addAll(await getSellers());
    }catch(e){
      sellers = [];
    }

    var seller = jsonEncode({
      "ticket":name,
      "date_seller":DateTime.now().toString(),
      "price":price,
      "duration":duration,
      "profile":profile
    });

    sellers.add(seller);
    try{
      await FirebaseDatabase.instance
          .ref('users/${sessionCubit?.state.firebaseID}/seller')
          .set(sellers);
      return true;
    }catch (e){
      return false;
    }
  }

  Future getSellers()async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/${sessionCubit?.state.firebaseID}/seller').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return [];
    }
  }

  Future<bool> updateContact(String phone)async{
    try{
      await FirebaseDatabase.instance
          .ref('users/${sessionCubit?.state.firebaseID}/phone')
          .set(phone);
      return true;
    }catch (e){
      return false;
    }
  }

  Future getContact()async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/${sessionCubit?.state.firebaseID}/phone').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return null;
    }
  }

}
