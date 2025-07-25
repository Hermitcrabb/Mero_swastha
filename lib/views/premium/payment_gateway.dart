import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentGateway extends StatelessWidget {
  // Test Credentials
  static const String CLIENT_ID = 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R';
  static const String SECRET_KEY = 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==';

  Future<void> markUserAsPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'isPremium': true,
        'premiumActivatedAt': FieldValue.serverTimestamp(),
      });
      print('User marked as Premium successfully!');
    } catch (e) {
      print('Error updating premium status: $e');
    }
  }

  Future<void> verifyTransactionStatus(String refId) async {
    final url = 'https://rc.esewa.com.np/mobile/transaction?txnRefId=$refId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'merchantId': 'YOUR_MERCHANT_ID',         // TODO: Replace with your Merchant ID
        'merchantSecret': 'YOUR_MERCHANT_SECRET', // TODO: Replace with your Merchant Secret
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final transactionDetails = data[0]['transactionDetails'];
        final status = transactionDetails['status'];
        final refId = transactionDetails['referenceId'];

        if (status == 'COMPLETE') {
          print('Transaction Verified Successfully! RefId: $refId');
          await markUserAsPremium();  // Mark user as premium on successful verification
        } else {
          print('Transaction Verification Failed. Status: $status');
        }
      } else {
        print('Invalid Response from Verification API');
      }
    } else {
      print('Failed to verify transaction. StatusCode: ${response.statusCode}');
    }
  }

  void startEsewaPayment(BuildContext context) {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,  // Use Environment.live for production
          clientId: CLIENT_ID,
          secretId: SECRET_KEY,
        ),
        esewaPayment: EsewaPayment(
          productId: "TEST123",
          productName: "Test Product",
          productPrice: "100",
          callbackUrl: '',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          debugPrint("Payment Success => $data");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Successful! RefId: ${data.refId}')),
          );

          // Optional: Simulate verification (or call verifyTransactionStatus in Production)
          Future.delayed(Duration(seconds: 2), () async {
            print('Simulated Transaction Verified Successfully! RefId: ${data.refId}');
            await markUserAsPremium();
          });
        },
        onPaymentFailure: (data) {
          debugPrint("Payment Failure => $data");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Failed!')),
          );
        },
        onPaymentCancellation: (data) {
          debugPrint("Payment Cancelled => $data");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Cancelled!')),
          );
        },
      );
    } catch (e) {
      debugPrint("EXCEPTION: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('eSewa Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => startEsewaPayment(context),
          child: Text('Pay with eSewa'),
        ),
      ),
    );
  }
}
