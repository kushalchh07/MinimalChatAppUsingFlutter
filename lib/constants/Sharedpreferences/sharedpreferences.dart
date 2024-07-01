import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../pages/SplashScreen&onBoard/splashScreen.dart';

Future<void> saveName(String name) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString('name', name);

  print("Name saved to device.");
  log("Name Saved to device" );
}

Future<void> clearData() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove('name');
  prefs.remove('email_address');
  prefs.remove('contact');

  print("Cleared All the data.");
}

Future<String?> getName() async {
  var prefs = await SharedPreferences.getInstance();
  String? name = prefs.getString('name');
  print(name);
  print("Name fetched from device.");
  // getImage();
  return name;
}

Future<void> saveEmail(String email) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString('email_address', email);

  log("Email saved to device.");
}

Future<void> loadEmail(String email) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString('email_address', email);

  log("Email saved to device.");
}

Future<String?> getEmail() async {
  var prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email_address');
  log('get email bata aako ${email}');
  return email;
}

Future<void> saveContact(String contact) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString('contact', contact);

  log("Contact saved to device.");
}
// String? contact;
// Future<void> loadContact() async {
//   contact = await getContact();
//   log(contact.toString() + "saved contact");
// }

Future<String?> getContact() async {
  var prefs = await SharedPreferences.getInstance();
  String? contact = prefs.getString('contact');
  print(contact);
  return contact;
}

Future<void> saveStatus(bool status) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool(SplashScreen.KEYLOGIN, status);
}
