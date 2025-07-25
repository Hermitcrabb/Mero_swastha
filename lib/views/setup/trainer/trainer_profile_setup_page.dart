import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img_lib;
import 'dart:typed_data';

class TrainerProfileSetupPage extends StatefulWidget {
  const TrainerProfileSetupPage({Key? key}) : super(key: key);

  @override
  State<TrainerProfileSetupPage> createState() => _TrainerProfileSetupPageState();
}

class _TrainerProfileSetupPageState extends State<TrainerProfileSetupPage> {
  final TextEditingController _bioController = TextEditingController();
  final List<File> _selectedImages = [];
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) return;

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImages.add(File(picked.path));
      });
    }
  }

  Future<String?> _uploadImageToImgbb(File imageFile) async {
    const imgbbApiKey = '23ab4316f6de968c976bb88fb5fb1f79';
    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey");

    try {
      // Load image and resize
      final originalBytes = await imageFile.readAsBytes();
      img_lib.Image? image = img_lib.decodeImage(originalBytes);
      if (image == null) {
        print('❌ Failed to decode image.');
        return null;
      }

      // Resize image to width of 800px (or smaller if image is small)
      final resizedImage = img_lib.copyResize(image, width: 800);

      // Encode to JPEG with 75% quality
      final jpgBytes = img_lib.encodeJpg(resizedImage, quality: 75);
      final base64Image = base64Encode(Uint8List.fromList(jpgBytes));

      final response = await http.post(url, body: {
        'image': base64Image,
      });

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data']['url'];
      } else {
        print('❌ Failed to upload image: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Upload Error: $e');
      return null;
    }
  }

  Future<void> _submitProfile() async {
    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    List<String> imageUrls = [];

    for (var image in _selectedImages) {
      final url = await _uploadImageToImgbb(image);
      if (url != null) imageUrls.add(url);
    }

    final trainerData = {
      'AboutYourself': _bioController.text.trim(),
      'imageUrls': imageUrls,
      'profileCompleted': true,
    };

    try {
      await FirebaseFirestore.instance.collection('trainers').doc(user.uid).set(trainerData, SetOptions(merge: true));
    } catch (e) {
      print('❌ Firestore Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Failed to save profile. Please try again.")));
      setState(() => _isSubmitting = false);
      return;
    }


    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile setup complete!"))
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Profile Setup'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About You",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                hintText: "Write a short bio...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 25),
            Text(
              "Add up to 3 Photos",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ..._selectedImages.map(
                      (file) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                ),
                if (_selectedImages.length < 3)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.primaryColor),
                      ),
                      child: Icon(Icons.add_a_photo, color: theme.primaryColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitProfile,
                icon: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check),
                label: Text(_isSubmitting ? "Submitting..." : "Submit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
