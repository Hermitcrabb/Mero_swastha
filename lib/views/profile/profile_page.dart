import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart'; // Make sure you import the login page

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  // Function to update the user's name in Firebase
  Future<void> _updateName() async {
    try {
      await user.updateDisplayName(_nameController.text.trim());
      await user.reload();
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating name: $e")),
      );
    }
  }

  // Function to handle logout and redirect to login page
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const Login()); // Navigate to the login page after logout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Ensure this triggers the logout functionality
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
              child: user.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 20),
            _isEditing
                ? TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Update Name',
                border: OutlineInputBorder(),
              ),
            )
                : Text(
              user.displayName ?? 'No Name Set',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _isEditing
                ? ElevatedButton(
              onPressed: _updateName,
              child: const Text('Save'),
            )
                : TextButton(
              onPressed: () {
                _nameController.text = user.displayName ?? '';
                setState(() {
                  _isEditing = true;
                });
              },
              child: const Text('Edit Name'),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              child: ListTile(
                title: const Text("Email"),
                subtitle: Text(user.email ?? 'No Email Set'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
