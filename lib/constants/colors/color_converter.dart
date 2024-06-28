import 'package:flutter/material.dart';

class ColorConverter {
  Color hexColor({required dynamic color}) {
    dynamic col = color.replaceAll('#', '0xFF');
    return Color(int.parse(col));
  }

  rgba({required String color}) {}
}
