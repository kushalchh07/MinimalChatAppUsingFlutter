// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:chat_app/pages/screen/base.dart';
import 'package:chat_app/repository/payment_repo.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/colors/colors.dart';
import '../../utils/customWidgets/alert_dialog_box.dart';
import 'package:http/http.dart' as http;

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String? selectedPaymentMethod;
  dynamic product = "Premium";
  dynamic price = 200;
  dynamic date = DateTime.now();
  dynamic productId = "123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        elevation: 0,
        title: Text("Subscription"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Product:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:
                              Text("$product", style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Product ID:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('$productId',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Price:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('$price', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Date:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('$date', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Status:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Paid', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Select Payment Method:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildPaymentMethodOption(
                    "esewa", "assets/payments/e-sewa.png"),
                SizedBox(width: 10),
                _buildPaymentMethodOption(
                    "khalti", "assets/payments/khalti.png"),
              ],
            ),
            Spacer(),
            if (selectedPaymentMethod != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedPaymentMethod == "esewa") {
                      payEsewa(productId, product, price, context);
                    } else if (selectedPaymentMethod == "khalti") {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => KhaltiPaymentPage(
                      //       product: product,
                      //       productId: productId,
                      //       price: price,
                      //       date: date,
                      //     ),
                      //   ),
                      // );
                    }
                  },
                  child: Text("Proceed to Payment"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
        log("selected method : $selectedPaymentMethod");
      },
      child: Card(
        color:
            selectedPaymentMethod == method ? Colors.green[100] : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            assetPath,
            width: 100,
            height: 50,
          ),
        ),
      ),
    );
  }
}

payEsewa(
  dynamic productid,
  dynamic product,
  dynamic price,
  BuildContext context,
) {
  log("pay esews initialized");
  try {
    EsewaFlutterSdk.initPayment(
      esewaConfig: EsewaConfig(
        environment: Environment.test,
        //test ko lagi
        clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
        secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
      ),
      esewaPayment: EsewaPayment(
        productId: "$productid",
        productName: "$product",
        productPrice: "$price",
        callbackUrl: '',
      ),
      onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
        debugPrint(":::SUCCESS::: => $data");
        log("Success" + data.toString());
        verifyTransactionStatus(data, context);
      },
      onPaymentFailure: (data) {
        debugPrint(":::FAILURE::: => $data");
        log("failure" + data.toString());
      },
      onPaymentCancellation: (data) {
        debugPrint(":::CANCELLATION::: => $data");
        log("cancel" + data.toString());
      },
    );
  } on Exception catch (e) {
    debugPrint("EXCEPTION : ${e.toString()}");
    log("Exception" + e.toString());
  }
}

void verifyTransactionStatus(
    EsewaPaymentSuccessResult result, BuildContext context) async {
  Map data = result.toJson();
  EsewaRepository esewaRepository = EsewaRepository();
  var response = await callVerificationApi(data['refId']);
  log("The Response Is: ${response.body}");
  log("The Response Status Code Is: ${response.statusCode}");

  if (response.statusCode.toString() == "200") {
    // await esewaRepository.fetchTransaction(data['refId']);
    paymentSuccessAlert(context);
  } else {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: Text('Verification Failed'),
            ));
  }
}

callVerificationApi(result) async {
  print("TxnRefd Id: " + result);

  var response = await http.get(
    Uri.parse("https://esewa.com.np/mobile/transaction?txnRefId=$result"),
    headers: {
      'Content-Type': 'application/json',
      // Test ko lagi
      'merchantSecret': 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
      'merchantId': 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
    },
  );
  print("Call Verification Api: ${response.statusCode}");
  return response;
}

paymentSuccessAlert(BuildContext context) {
  return customAlertBox(
    context,
    'Your payment was successful',
    '',
    () {},
    'OK',
    () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Base(
                    indexNum: 0,
                  )),
          (route) => false);
    },
  );
}
