import 'package:flutter/material.dart';

class AppSize extends StatelessWidget {
  final context;
  const AppSize({super.key, required this.context});

  height() {
    return MediaQuery.of(context).size.height;
  }

  width() {
    return MediaQuery.of(context).size.width;
  }

  boldText() => height() * 0.025;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
