import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTrainerProfilePage extends StatefulWidget {
  final String trainerId;

  const EditTrainerProfilePage({Key? key, required this.trainerId}) : super(key: key);

  @override
  State<EditTrainerProfilePage> createState() => _EditTrainerProfilePageState();
}

class _EditTrainerProfilePageState extends State<EditTrainerProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _loadTrainerData();
  }

  Future<void> _loadTrainerData() async {
    var doc = await FirebaseFirestore.instance.collection('trainers').doc(widget.trainerId).get();
    var data = doc.data() ?? {};
    _nameController.text = data['name'] ?? '';
    _phoneController.text = data['phone'] ?? '';
    _locationController.text = data['location'] ?? '';
    _bioController.text = data['AboutYourself'] ?? '';
    imageUrls = List<String>.from(data['imageUrls'] ?? []);
    setState(() => isLoading = false);
  }

  Future<void> _uploadImage(File image) async {
    final apiKey = 'YOUR_IMGBB_API_KEY'; // Replace with your imgbb API key
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);
      final uploadedUrl = jsonResponse['data']['url'];
      setState(() => imageUrls.add(uploadedUrl));
    } else {
      throw Exception('Image upload failed');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await _uploadImage(File(picked.path));
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance.collection('trainers').doc(widget.trainerId).update({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'location': _locationController.text.trim(),
      'AboutYourself': _bioController.text.trim(),
      'imageUrls': imageUrls,
    });

    Navigator.pop(context); // Go back after saving
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: imageUrls
                    .map((url) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(url, height: 100, width: 100, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => imageUrls.remove(url));
                        },
                        child: const Icon(Icons.cancel, color: Colors.red, size: 20),
                      ),
                    )
                  ],
                ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickAndUploadImage,
                icon: const Icon(Icons.image),
                label: const Text("Add Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) => val == null || val.isEmpty ? "Enter phone" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (val) => val == null || val.isEmpty ? "Enter location" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: "About Yourself"),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? "Enter bio" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
