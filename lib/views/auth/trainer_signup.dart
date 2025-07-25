import 'package:firebase_auth/firebase_auth.dart';
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
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final customSkillsController = TextEditingController();
  final experienceController = TextEditingController();

  final List<String> availableSkills = [
    'Yoga',
    'Strength Training',
    'Zumba',
    'Cardio',
    'Motivation',
    'Communication',
    'Nutrition',
    'HIIT',
    'Technical',
    'Problem Solving',
  ];

  final List<String> selectedSkills = [];

  // Live validation states
  String? nameError;
  String? emailError;
  String? phoneError;
  String? addressError;
  String? experienceError;

  bool get isFormValid =>
      nameError == null &&
          emailError == null &&
          phoneError == null &&
          addressError == null &&
          experienceError == null &&
          nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          experienceController.text.isNotEmpty;

  void _addCustomSkill() {
    final skill = customSkillsController.text.trim();
    if (skill.isNotEmpty && !selectedSkills.contains(skill)) {
      setState(() {
        selectedSkills.add(skill);
        customSkillsController.clear();
      });
    }
  }

  bool isValidName(String name) {
    final nameRegEx = RegExp(r"^[a-zA-Z\s]+$");
    return nameRegEx.hasMatch(name);
  }

  bool isValidEmail(String email) {
    final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegEx.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    final phoneRegEx = RegExp(r'^\d{10}$');
    return phoneRegEx.hasMatch(phone);
  }

  void validateName(String value) {
    if (value.trim().isEmpty) {
      nameError = 'Name is required';
    } else if (!isValidName(value.trim())) {
      nameError = 'Only letters and spaces allowed';
    } else {
      nameError = null;
    }
  }

  void validateEmail(String value) {
    if (value.trim().isEmpty) {
      emailError = 'Email is required';
    } else if (!isValidEmail(value.trim())) {
      emailError = 'Invalid email format';
    } else {
      emailError = null;
    }
  }

  void validatePhone(String value) {
    if (value.trim().isEmpty) {
      phoneError = 'Phone number is required';
    } else if (!isValidPhone(value.trim())) {
      phoneError = 'Must be exactly 10 digits';
    } else {
      phoneError = null;
    }
  }

  void validateAddress(String value) {
    if (value.trim().isEmpty) {
      addressError = 'Address is required';
    } else {
      addressError = null;
    }
  }

  void validateExperience(String value) {
    final years = int.tryParse(value);
    if (value.trim().isEmpty) {
      experienceError = 'Experience is required';
    } else if (years == null) {
      experienceError = 'Invalid number';
    } else if (years < 0 || years > 50) {
      experienceError = 'Must be between 0 and 50';
    } else {
      experienceError = null;
    }
  }

  Future<void> _submitForm() async {
    if (!isFormValid) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to submit.')),
        );
        return;
      }

      final trainerData = {
        "uid": user.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "location": addressController.text.trim(),
        "bio":
        "Certified trainer with ${experienceController.text.trim()} years experience. Skills: ${selectedSkills.join(', ')}",
        "photoUrl": "",
        "status": "pending",
      };

      await FirebaseFirestore.instance
          .collection('trainer_applications')
          .doc(user.uid)
          .set(trainerData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trainer profile submitted successfully!')),
      );
      Get.back();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(12),
      ),
      errorMaxLines: 2,
    );
  }

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      setState(() {
        validateName(nameController.text);
      });
    });
    emailController.addListener(() {
      setState(() {
        validateEmail(emailController.text);
      });
    });
    phoneController.addListener(() {
      setState(() {
        validatePhone(phoneController.text);
      });
    });
    addressController.addListener(() {
      setState(() {
        validateAddress(addressController.text);
      });
    });
    experienceController.addListener(() {
      setState(() {
        validateExperience(experienceController.text);
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    customSkillsController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Signup'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply as Trainer',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextField(
              controller: nameController,
              decoration: _inputDecoration('Full Name', Icons.person).copyWith(
                errorText: nameError,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('Email Address', Icons.email).copyWith(
                errorText: emailError,
              ),
            ),
            const SizedBox(height: 8),

            // Phone
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration('Phone Number', Icons.phone).copyWith(
                errorText: phoneError,
              ),
            ),
            const SizedBox(height: 8),

            // Address
            TextField(
              controller: addressController,
              decoration: _inputDecoration('Address', Icons.location_on).copyWith(
                errorText: addressError,
              ),
            ),
            const SizedBox(height: 8),

            // Experience
            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Experience (in years)', Icons.work).copyWith(
                errorText: experienceError,
              ),
            ),
            const SizedBox(height: 16),

            Text('Select Your Skills:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 12),

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
            const SizedBox(height: 12),

// After the staple skills ChoiceChips:
            const SizedBox(height: 12),

// Custom skill input + add button row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customSkillsController,
                    decoration: const InputDecoration(
                      hintText: 'Add custom skill',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCustomSkill,
                ),
              ],
            ),

            const SizedBox(height: 12),

// Show selected skills as chips
            Wrap(
              spacing: 6,
              children: selectedSkills.map((s) => Chip(label: Text(s))).toList(),
            ),


            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isFormValid ? _submitForm : null,
                icon: const Icon(Icons.check),
                label: const Text("Submit Application"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: const Text(
                'Please send your CV and profile picture to:\nmeroswastha01@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
