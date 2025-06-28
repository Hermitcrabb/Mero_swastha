import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '/homepage.dart'; // or wherever your Homepage screen is

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String gender = 'Male';
  int age = 18;
  double height = 170;
  double weight = 70;
  String activityLevel = 'Sedentary';

  bool isLoading = false;

  void saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel,
        'email': user.email,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offAll(() => const Homepage());
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Up Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onSaved: (val) => name = val!.trim(),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => gender = val!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: age.toString(),
                      decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => age = int.tryParse(val ?? '') ?? 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: height.toString(),
                      decoration: const InputDecoration(labelText: "Height (cm)", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => height = double.tryParse(val ?? '') ?? 170,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: weight.toString(),
                      decoration: const InputDecoration(labelText: "Weight (kg)", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => weight = double.tryParse(val ?? '') ?? 70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Activity Level", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: activityLevel,
                items: const [
                  DropdownMenuItem(value: 'Sedentary', child: Text('Sedentary')),
                  DropdownMenuItem(value: 'Lightly active', child: Text('Lightly active')),
                  DropdownMenuItem(value: 'Moderately active', child: Text('Moderately active')),
                  DropdownMenuItem(value: 'Very active', child: Text('Very active')),
                ],
                onChanged: (val) => activityLevel = val!,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Save Profile", style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
