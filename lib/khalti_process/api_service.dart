import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> verifyKhaltiPayment(String token, int amount) async {
  print('🔔 Sending token: $token and amount: $amount to backend server...');
  final url = Uri.parse(
    'http://192.168.1.72:5000/verify-khalti-payment',
  ); // Replace <YOUR-IP>

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'amount': amount}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ Payment Verified: ${data['data']}');
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      print('❌ Verification Failed: ${errorData['message']}');
      return false;
    }
  } catch (e) {
    print('❗ API Error: $e');
    return false;
  }
}
