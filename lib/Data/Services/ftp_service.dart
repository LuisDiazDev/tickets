import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';

class FtpService {
  static late FTPConnect _ftpConnect;
  static bool _init = false;

  static initService({String address = "", String user = "", String pass = ""}) {
    _ftpConnect = FTPConnect(address, user: user, pass: pass);
    _init = true;
  }

  static Future<dynamic> getFiles({dynamic arguments}) async {
    if(_init){
      await _ftpConnect.connect();
      var list = await _ftpConnect.listDirectoryContentOnlyNames();
      await _ftpConnect.disconnect();
      return list;
    }else{
      return [];
    }
  }

  static Future uploadFile({required File file,String? remoteName})async{
    if(_init){
      await _ftpConnect.connect();
      var r = await _ftpConnect.uploadFile(file,sRemoteName: remoteName??"backup.backup");
      await _ftpConnect.disconnect();
      return r;
    }else{
      return false;
    }
  }

  static Future downloadFile({String? remoteName,required File file})async{
    if(_init){
      await _ftpConnect.connect();
      var r = await _ftpConnect.downloadFile(remoteName,file);
      await _ftpConnect.disconnect();
      return r;
    }else{
      return false;
    }
  }

  static Future checkFile({String? remoteName})async{
    if(_init){
      await _ftpConnect.connect();
      var r = await _ftpConnect.existFile(remoteName??"backup.backup");
      await _ftpConnect.disconnect();
      return r;
    }else{
      return false;
    }
  }
}
