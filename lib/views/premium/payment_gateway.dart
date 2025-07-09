import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentGatewayPage extends StatelessWidget {
  const PaymentGatewayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Unlock premium features by paying securely through Khalti.\n'
                  'You’ll get access to expert trainers, personal chat, and exclusive tools!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                KhaltiScope.of(context).pay(
                  config: PaymentConfig(
                    amount: 50000, // in paisa (e.g. Rs. 500)
                    productIdentity: 'premium_subscription',
                    productName: 'Premium Plan',
                  ),
                  preferences: [
                    PaymentPreference.khalti,
                    PaymentPreference.eBanking,
                    PaymentPreference.mobileBanking,
                    PaymentPreference.connectIPS,
                  ],
                  onSuccess: (success) {
                    // TODO: Update user's premium status in Firestore
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment Successful!')),
                    );
                  },
                  onFailure: (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment Failed.')),
                    );
                  },
                );
              },
              child: const Text(
                'Proceed to Pay',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}