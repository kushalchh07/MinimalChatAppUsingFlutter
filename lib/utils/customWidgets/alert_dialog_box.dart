import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';


void customAlertBox(
  context,
  String content,
  String button1Text,
  void Function()? ontap1,
  String button2Text,
  void Function()? ontap2,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actionsAlignment: button1Text == ''
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        contentTextStyle: GoogleFonts.inter(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: Text(content),
        actions: <Widget>[
          button1Text == ''
              ? const SizedBox.shrink()
              : Container(
                  width: Get.width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: textColor,
                        width: 1,
                      )),
                  child: TextButton(
                    onPressed: ontap1,
                    child: Text(
                      button1Text,
                      style: GoogleFonts.inter(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
          Container(
            width: button1Text == '' ? Get.width * 0.9 : Get.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: textColor,
                width: 1,
              ),
              color: textColor,
            ),
            child: TextButton(
              onPressed: ontap2,
              child: Text(
                button2Text,
                style: GoogleFonts.inter(
                  color: whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
