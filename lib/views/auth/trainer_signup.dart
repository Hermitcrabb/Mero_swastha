import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerSignupPage extends StatefulWidget {
  const TrainerSignupPage({super.key});

  @override
  State<TrainerSignupPage> createState() => _TrainerSignupPageState();
}


class _TrainerSignupPageState extends State<TrainerSignupPage> {
    final _formKey = GlobalKey<FormState>();
    final  nameController = TextEditingController();
    final  addressController = TextEditingController();
    final  emailController = TextEditingController();
    final  phoneController = TextEditingController();
    final  customskillsController = TextEditingController();
    final  experienceController = TextEditingController();

    final List<String> availableSkills = [
      'Yoga',
      'Strength Training',
      'Zumba',
      'Cardio',
      'Motivation',
      'Communication',
      'Nutrition',
      'HIIT (high intensity interval training)',
      'Technical',
      'Problem Solving',
    ];
    final List<String> selectedSkills =[];

    void _addCustomSkill() {
      final skill = customskillsController.text.trim();
      if (skill.isNotEmpty && !selectedSkills.contains(skill)) {
        setState(() {
          selectedSkills.add(skill);
          customskillsController.clear();
        });
      }
    }

    Future<void> _submitForm() async {
      if (_formKey.currentState!.validate()) {
        final trainerData = {
          'Name': nameController.text.trim(),
          'Address': addressController.text.trim(),
          'Email': emailController.text.trim(),
          'Phone': phoneController.text.trim(),
          'Skills': selectedSkills,
          'Experience': experienceController.text.trim(),
          'SubmittedAt': FieldValue.serverTimestamp(),
        };
        try {
          await FirebaseFirestore.instance
              .collection('trainer_applications')
              .add(
              trainerData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Application submitted successfully!')),
          );
          //Go Back to profile view page
          Get.back();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trainer Signup')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Apply as Trainer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                ),

                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Enter your phone number' : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: experienceController,
                  decoration: const InputDecoration(labelText: 'Experience (in years)'),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),
                const Text('Select Your Skills:', style: TextStyle(fontSize: 16)),
                Wrap(
                  spacing: 8,
                  children: availableSkills.map((skill) {
                    final isSelected = selectedSkills.contains(skill);
                    return ChoiceChip(
                      label: Text(skill),
                      selected: isSelected,
                      selectedColor: Colors.deepPurple.shade100,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedSkills.add(skill);
                          } else {
                            selectedSkills.remove(skill);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: customskillsController,
                        decoration: const InputDecoration(hintText: 'Add custom skill'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCustomSkill,
                    )
                  ],
                ),

                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: selectedSkills.map((s) => Chip(label: Text(s))).toList(),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Please send your CV and profile picture to:\nmeroswastha01@gmail.com',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 14),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit Application"),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
