import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminTrainerApprovalPage extends StatefulWidget {
  @override
  _AdminTrainerApprovalPageState createState() => _AdminTrainerApprovalPageState();
}

class _AdminTrainerApprovalPageState extends State<AdminTrainerApprovalPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
  }

  Future<void> checkAdminStatus() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()?['role'] == 'admin') {
      setState(() {
        _isAdmin = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isAdmin = false;
        _isLoading = false;
      });
    }
  }

  Future<void> approveTrainer(String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('trainers').doc(docId).set({
        ...data,
        'status': 'approved',
      });

      await _firestore.collection('trainer_applications').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Trainer approved")),
      );
    } catch (e) {
      print("❌ Error approving trainer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error approving trainer")),
      );
    }
  }

  Future<void> rejectTrainer(String docId) async {
    try {
      await _firestore.collection('trainer_applications').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Trainer application rejected")),
      );
    } catch (e) {
      print("❌ Error rejecting trainer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Trainer Applications")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text("Access Denied")),
        body: Center(child: Text("🚫 You are not authorized to view this page.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Trainer Applications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('trainer_applications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("❌ Error loading applications"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("📭 No pending trainer applications"));
          }

          final applications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final doc = applications[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text(data['name'] ?? 'Unnamed'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${data['email'] ?? 'N/A'}"),
                      if (data['experience'] != null)
                        Text("Experience: ${data['experience']} years"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        tooltip: 'Approve',
                        onPressed: () => approveTrainer(doc.id, data),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        tooltip: 'Reject',
                        onPressed: () => rejectTrainer(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
