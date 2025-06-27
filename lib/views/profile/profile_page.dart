import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  String _gender = 'Male';
  String _mealType = 'Vegetarian';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data != null) {
      _gender = data['Gender'] ?? _gender;
      _mealType = data['MealType'] ?? _mealType;

      final height = data['Height'];
      final weight = data['Weight'];
      final age = data['Age'];

      if (height != null) _heightController.text = height.toString();
      if (weight != null) _weightController.text = weight.toString();
      if (age != null) _ageController.text = age.toString();
    }

    setState(() {});
  }

  Future<void> _updateProfile() async {
    setState(() => _isSaving = true);
    try {
      await user.updateDisplayName(_nameController.text.trim());
      await user.reload();

      final Map<String, dynamic> updatedData = {
        'Gender': _gender,
        'MealType': _mealType,
      };

      final heightText = _heightController.text.trim();
      final weightText = _weightController.text.trim();
      final ageText = _ageController.text.trim();

      final parsedHeight = double.tryParse(heightText);
      final parsedWeight = double.tryParse(weightText);
      final parsedAge = double.tryParse(ageText);

      if (parsedHeight != null) updatedData['Height'] = parsedHeight;
      if (parsedWeight != null) updatedData['Weight'] = parsedWeight;
      if (parsedAge != null) updatedData['Age'] = parsedAge;

      await _firestore.collection('users').doc(user.uid).set(
        updatedData,
        SetOptions(merge: true),
      );

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    final hasValidPhoto = user.photoURL != null && user.photoURL!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: hasValidPhoto ? NetworkImage(user.photoURL!) : null,
              child: !hasValidPhoto ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 20),
            _isEditing
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Update Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age (years)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: "Gender"),
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _gender = value);
                  },
                ),
                const SizedBox(height: 10),
                const Text("Meal Type"),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Vegetarian',
                      groupValue: _mealType,
                      onChanged: (value) => setState(() => _mealType = value!),
                    ),
                    const Text('Vegetarian'),
                    Radio<String>(
                      value: 'Non-Vegetarian',
                      groupValue: _mealType,
                      onChanged: (value) => setState(() => _mealType = value!),
                    ),
                    const Text('Non-Vegetarian'),
                  ],
                ),
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                const SizedBox(height: 10),
                _isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Save'),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName ?? 'No Name Set',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Email: ${user.email}"),
                Text("Age: ${_ageController.text.isEmpty ? 'Not set' : '${_ageController.text} years'}"),
                Text("Gender: $_gender"),
                Text("Meal Type: $_mealType"),
                Text("Height: ${_heightController.text.isEmpty ? 'Not set' : '${_heightController.text} cm'}"),
                Text("Weight: ${_weightController.text.isEmpty ? 'Not set' : '${_weightController.text} kg'}"),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    _nameController.text = user.displayName ?? '';
                    setState(() => _isEditing = true);
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
