import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<List<String?>> getDeviceDetails() async {
  String? deviceName;
  String? deviceVersion;
  String? identifier;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.id;  //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor;  //UUID for iOS
    }
  } on Exception {
    log('Failed to get platform version');
    return [];
  }
  //if (!mounted) return;
  return [deviceName, deviceVersion, identifier];
}


Future<String> identifier() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor!; // unique ID on iOS
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}

