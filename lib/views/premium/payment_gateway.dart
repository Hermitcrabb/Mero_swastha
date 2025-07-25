import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../khalti_process/api_service.dart';

const bool isDemo = false;

class PaymentGatewayPage extends StatelessWidget {
  const PaymentGatewayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Unlock premium features by paying securely through Khalti.\n'
              'You’ll get access to expert trainers, personal chat, and exclusive tools!\n'
              'For Premium Feature the cost is NRs 500.\n',

              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not logged in')),
                  );
                  return;
                }

                if (isDemo) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({'isPremium': true});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demo Payment Successful!')),
                  );

                  Navigator.pushNamed(context, '/trainer_list');
                } else {
                    print('Proceed button pressed');
                KhaltiScope.of(context).pay(
                    config: PaymentConfig(
                      amount: 50000,
                      productIdentity: 'premium_subscription',
                      productName: 'Premium Plan',
                    ),
                    preferences: [
                      PaymentPreference.khalti,
                      // PaymentPreference.eBanking,
                      // PaymentPreference.connectIPS,
                    ],
                    onSuccess: (success) async {
                      print('Khalti payment success token: ${success.token}');
                      print('Khalti payment success amount: ${success.amount}');

                      bool isPaymentVerified = await verifyKhaltiPayment(
                        success.token,
                        success.amount,
                      );

                      print('Payment verified result: $isPaymentVerified');

                      if (isPaymentVerified) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'isPremium': true});

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Verified & Successful!')),
                        );

                        Navigator.pushNamed(context, '/trainer_list');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment verification failed. Try again.')),
                        );
                      }
                    },
                    onFailure: (failure) {
                        print('❌ Payment Failure Reason: ${failure.toString()}');

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Failed.')),
                        );
                      },
                  );
                }
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
