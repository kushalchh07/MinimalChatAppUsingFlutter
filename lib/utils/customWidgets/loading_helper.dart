import 'package:chat_app/utils/customWidgets/lazy_loading.dart';
import 'package:flutter/material.dart';
// import 'loading_screen.dart';

void showLoadingScreen(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingScreen();
    },
  );
}

void hideLoadingScreen(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
