import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PremiumChecker extends StatelessWidget {
  final Widget premiumChild;
  final Widget? nonPremiumChild;

  const PremiumChecker({
    required this.premiumChild,
    this.nonPremiumChild,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return nonPremiumChild ?? Center(child: Text('Please login'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return nonPremiumChild ?? const Center(child: Text('User data not found'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        final isPremium = data?['isPremium'] ?? false;

        if (isPremium) {
          return premiumChild;
        } else {
          return nonPremiumChild ?? const Center(child: Text('Premium feature — Upgrade to access'));
        }
      },
    );
  }
}
