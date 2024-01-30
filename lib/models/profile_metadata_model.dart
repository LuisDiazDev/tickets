enum DurationType {
  Unknown,
  // Tiempo corrido
  RunningTime,
  // Guardar tiempo
  SaveTime
}

class ParseResult {
  List<String> warnings;
  String profileName = "";
  ProfileMetadata? profile;

  ParseResult(this.warnings,this.profileName, this.profile);
}

class ProfileMetadata {
  String hotspot;
  double price;
  String prefix;
  int userLength;
  int passwordLength;
  String usageTime;
  int dataLimit;
  DurationType durationType;
  bool isNumericUser;
  bool isNumericPassword;
  String? onLogin;
  String? type;

  ProfileMetadata({
    required this.hotspot,
    required this.price,
    required this.prefix,
    required this.userLength,
    required this.passwordLength,
    required this.usageTime,
    required this.dataLimit,
    required this.durationType,
    required this.isNumericUser,
    required this.isNumericPassword,
    required this.type
  });

  // Parsea un string con el formato de un perfil de mikrotiket
  // Inicia con la palabra "profile_" y luego viene el nombre del perfil.Los campos están separados por dos puntos (:)
  // El resto de campos son opcionales y pueden estar en cualquier orden pero siempre deben empezar con el nombre del campo y dos puntos (:)
  // Ejemplo: "profile_nombre-se:hotspot1-co:0.0-pr:pre-lu:7-lp:7-ut:3d-00:00:00-bt:200-kt:true-nu:true-np:true-tp:1"
  //      profile_Nuevo plan5-se:hotspot1-co:11.0-pr:-lu:5-lp:5-ut:01d-00:00:00-bt:0-kt:true-nu:true-np:true
  //         profile_tttg hhh-se:hotspot1-co:20.0-pr:-lu:7-lp:7-ut:01d-00:00:00-bt:null-kt:false-nu:true-np:true-tp:1
  // nombre: Nombre del perfil | nombre
  // se: Hotspot | hotspot1
  // co: Costo | 123.0
  // pre: Prefijo | pre
  // lu: Longitud de la clave del usuario | 7
  // lp: Longitud de la clave del password | 5
  // ut: Usage time | 10d-11:12:00
  // bt: limite total de datos en megabytes (MB) | 17
  // kt: Tipo de duración de ticket | Si es false entonces es de tipo “Tiempo corrido” y si es false es de tipo “Guardar tiempo”
  // nu: Usuario numérico | si es true entonces el password solo tendrá números
  // np: Contraseña numérica | si es true entonces las contraseñas solo tendrán números
  // tp: Tipo de perfil | 1 si es usuario/pass o 2 si es pin

  static ParseResult parseFromMikrotiketNameString(String profileStr) {
    Map<String, String> map = {};
    String startMark = "profile_";

    profileStr = profileStr.replaceAll("d-", "d_");
    if (!profileStr.startsWith(startMark)) {
      throw Exception("El nombre del perfil debe iniciar con $startMark");
    }
    List<String> sp = profileStr.split("-");
    for (int i = 0; i < sp.length; i++) {
      if (i == 0) {
        map["name"] = sp[0];
      } else {
        var sepIDx = sp[i].indexOf(":");
        var kv = [sp[i].substring(0, sepIDx), sp[i].substring(sepIDx + 1)];
        map[kv[0]] = kv[1];
        if (kv[0] == "ut") {
          map["ut"] = kv[1].replaceAll("_", "-");
        }
      }
    }
    List<String> warnings = [];
    String hotspot = "";
    double price = 0.0;
    String prefix = "";
    int userLength = 0;
    int passwordLength = 0;
    String usageTime = "";
    int dataLimit = 0;
    DurationType durationType = DurationType.RunningTime;
    bool isNumericUser = false;
    bool isNumericPassword = false;
    String type = "1";

    if (map.containsKey("se")) {
      hotspot = map["se"] ?? "";
    } else {
      warnings.add("No se ha especificado el hotspot");
    }

    if (map.containsKey("co")) {
      price = double.parse(map["co"] ?? "0.0");
    } else {
      warnings.add("No se ha especificado el costo");
    }

    if (map.containsKey("pr")) {
      prefix = map["pr"] ?? "";
    } else {
      warnings.add("No se ha especificado el prefijo");
    }

    if (map.containsKey("lu")) {
      userLength = int.parse(map["lu"] ?? "0");
    } else {
      warnings.add("No se ha especificado la longitud del usuario");
    }

    if (map.containsKey("lp")) {
      passwordLength = int.parse(map["lp"] ?? "0");
    } else {
      warnings.add("No se ha especificado la longitud de la contraseña");
    }

    if (map.containsKey("ut")) {
      usageTime = parseMkDateToDate(map["ut"] ?? "");
    } else {
      warnings.add("No se ha especificado el tiempo de uso");
    }

    if (map.containsKey("bt")) {
      dataLimit = int.parse(map["bt"] ?? "0");
    } else {
      dataLimit = 0;
    }

    if (map.containsKey("kt")) {
      durationType = map["kt"] == "true"
          ? DurationType.SaveTime
          : DurationType.RunningTime;
    } else {
      warnings.add("No se ha especificado el tipo de duración");
    }

    if (map.containsKey("nu")) {
      isNumericUser = map["nu"] == "true";
    } else {
      warnings.add("No se ha especificado si el usuario es numérico");
    }

    if (map.containsKey("np")) {
      isNumericPassword = map["np"] == "true";
    } else {
      warnings.add("No se ha especificado si la contraseña es numérica");
    }

    if (map.containsKey("tp")) {
      type = map["tp"] ?? "";
    } else {
      warnings.add("No se ha especificado el hotspot");
    }

    // String onLogin =
    //     '; {put (",rem,$price,$usageTime,$price,,Enable,Enable,"); :local voucher \$user; :if ([/system scheduler find name=\$voucher]="") do={/system scheduler add comment=\$voucher name=\$voucher interval=$usageTime on-event="/ip hotspot active remove [find user=\$voucher]\r\n/ip hotspot user remove [find name=\$voucher]\r\n/system schedule remove [find name=\$voucher]"}}';
    var name = map["name"] ?? "";
    name = name.replaceFirst(startMark, "");
    return ParseResult(
        warnings,
        name,
        ProfileMetadata(
          hotspot: hotspot,
          price: price,
          type: type,
          prefix: prefix,
          userLength: userLength,
          passwordLength: passwordLength,
          usageTime: usageTime,
          dataLimit: dataLimit,
          durationType: durationType,
          isNumericUser: isNumericUser,
          isNumericPassword: isNumericPassword,
        ));
  }

  static String _parseDuration(String duration){

    if(duration.contains("_") || duration.contains("-")){
      return duration;
    }

    String days="0d",hours="00",min="00";

    if(duration.contains("m")){
      min = duration.substring(0,duration.length - 1);
    }else if(duration.contains("h")){
      hours = duration.substring(0,duration.length - 1);
    }else if(duration.contains("d")){
      days = duration;
    }

    return "$days-$hours:$min:00";
  }

  String toMikrotiketNameString(String profileName) {
    String startMark = "profile_";

    String name = startMark + profileName;

    String hotspot = "se:${this.hotspot}";
    String price = "co:${this.price}";
    String prefix = "pr:${this.prefix}";
    String userLength = "lu:${this.userLength}";
    String passwordLength = "lp:${this.passwordLength}";
    String usageTime =
        "ut:${parseDateToMkDate(this.usageTime).replaceAll("-", "_")}";
    String dataLimit = "bt:${this.dataLimit}";
    String durationType = "kt:${this.durationType == DurationType.SaveTime}";
    String isNumericUser = "nu:${this.isNumericUser}";
    String isNumericPassword = "np:${this.isNumericPassword}";
    String type = "tp:${this.type}";
    return "$name-$hotspot-$price-$prefix-$userLength-$passwordLength-$usageTime-$dataLimit-$durationType-$isNumericUser-$isNumericPassword-$type";
  }

  static String parseMkDateToDate(String formatoFecha) {
    List<String> partes = formatoFecha.split("-");

    if (partes.length != 2) {
      throw Exception("Formato de fecha incorrecto");
    }

    int dias = 0, horas = 0, minutos = 0;

    // Procesar días
    if (partes[0].endsWith("d")) {
      dias = int.parse(partes[0].substring(0, partes[0].length - 1));
    } else {
      throw Exception("Formato de días incorrecto");
    }

    // Procesar horas, minutos y segundos
    List<String> tiempo = partes[1].split(":");
    if (tiempo.length != 3) {
      throw Exception("Formato de tiempo incorrecto");
    }

    horas = int.parse(tiempo[0]);
    minutos = int.parse(tiempo[1]);
    // Elegir la unidad más grande posible
    if (dias > 0) {
      return "${dias}d";
    } else if (horas > 0) {
      return "${horas}h";
    } else {
      return "${minutos}m";
    }
  }

  static String parseDateToMkDate(String valor) {
    return _parseDuration(valor);
    // RegExp exp = RegExp(r'(\d+)([dhm])');
    // Match match = exp.firstMatch(valor) as Match;

    // int cantidad = int.tryParse(match.group(1)!) ?? 0;
    // String unidad = match.group(2)!;

    // int dias = 0, horas = 0, minutos = 0;

    // switch (unidad) {
    //   case 'd':
    //     dias = cantidad;
    //     break;
    //   case 'h':
    //     horas = cantidad;
    //     break;
    //   case 'm':
    //     minutos = cantidad;
    //     break;
    //   default:
    //     throw Exception("Unidad de tiempo no válida");
    // }
    return valor;
    // return "${dias.toString()}d-${horas.toString().padLeft(2, '0')}:"
    //     "${minutos.toString().padLeft(2, '0')}:00";
  }
}
