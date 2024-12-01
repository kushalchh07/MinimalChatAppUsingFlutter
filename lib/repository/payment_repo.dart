import 'dart:convert';
import 'package:http/http.dart' as http;

class EsewaRepository {
  final String baseUrl = "https://rc.esewa.com.np/mobile/transaction";
  final String merchantId = "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";
  final String merchantSecret = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";

  Future<Map<String, dynamic>> fetchTransaction(String txnRefId) async {
    final url = Uri.parse("$baseUrl?txnRefId=$txnRefId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "merchantId": merchantId,
          "merchantSecret": merchantSecret,
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and return it
        return json.decode(response.body);
      } else {
        // Handle errors here, such as throwing an exception
        throw Exception('Failed to load transaction data');
      }
    } catch (e) {
      // Handle network errors here
      throw Exception('Failed to connect to the server');
    }
  }
}
