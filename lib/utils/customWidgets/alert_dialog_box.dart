import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

void customAlertBox(
  BuildContext context,
  String content,
  String button1Text,
  void Function()? ontap1,
  String button2Text,
  void Function()? ontap2,
) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          "Alert",
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            content,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        actions: <Widget>[
          button1Text == ''
              ? Container()
              : CupertinoDialogAction(
                  onPressed: ontap1,
                  child: Text(
                    button1Text,
                    style: GoogleFonts.inter(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: ontap2,
            child: Text(
              button2Text,
              style: GoogleFonts.inter(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}
