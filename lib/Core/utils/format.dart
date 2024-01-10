

String formatDuration(String duration){

  var num = duration.replaceAll(RegExp(r"\D"), "");
  var dim = _getDim(duration.replaceAll(num, ""));
  return "$num$dim";
}

String _getDim(String str){
  if(str == "m"){
    return "min";
  }else if(str == "h"){
    return "hora";
  }else if(str == "d"){
    return "dia";
  }else if(str == "s"){
    return "sem";
  }

  return str;
}