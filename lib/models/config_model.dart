class ConfigModel {
  String host, user, password;

  ConfigModel(
      {required this.password, required this.host, required this.user});

  static ConfigModel get defaultConfig =>
      ConfigModel(user: "admin", host: "192.168.10.2", password:"admin");
}
