import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = prefs.getString('userId') ?? '';
  return userID;
}

Future<String> getDepartmentId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String departmentID = prefs.getString('dpt_id') ?? '';
  return departmentID;
}
