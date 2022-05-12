import 'package:shared_preferences/shared_preferences.dart';
//shared_preferences supported Types: int, double, bool, string, and stringList

Future<SharedPreferences> _data = SharedPreferences.getInstance();

Future<void> set(String dataType, String key, var value) async {
  final SharedPreferences data = await _data;
  switch(dataType){
    case "int": data.setInt(key, value);
      break;
    case "double": data.setDouble(key, value);
      break;
    case "bool": data.setBool(key, value);
      break;
    case "string": data.setString(key, value);
      break;
    case "list": data.setStringList(key, value);
      break;
    default: data.setString(key, value);
  }
}

Future<int> getInt(String key) async {
  final SharedPreferences data = await _data;
  return (data.getInt(key) ?? -1);
}

Future<double> getDouble(String key) async {
  final SharedPreferences data = await _data;
  return (data.getDouble(key) ?? -1);
}

Future<bool> getBool(String key) async {
  final SharedPreferences data = await _data;
  return (data.getBool(key) ?? false);
}

Future<String> getString(String key) async {
  final SharedPreferences data = await _data;
  return (data.getString(key) ?? "");
}

Future<List> getList(String key) async {
  final SharedPreferences data = await _data;
  return (data.getStringList(key) ?? List.empty());
}

Future<void> remove(String key) async {
  final SharedPreferences data = await _data;
  data.remove(key);
}
