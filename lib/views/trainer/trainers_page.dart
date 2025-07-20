import 'package:flutter/material.dart';
import 'trainer_card.dart'; // import the TrainerCard widget

class TrainersPage extends StatelessWidget {
  final List<Map<String, String>> trainers = [
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'name': 'Ashish Roka',
      'phone': '+977-9800000000',
      'location': 'Kathmandu, Nepal',
      'bio': 'Certified personal trainer with 5+ years of experience helping clients achieve their goals.',
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'name': 'Sita Gurung',
      'phone': '+977-9800000001',
      'location': 'Pokhara, Nepal',
      'bio': 'Yoga expert and holistic health coach passionate about mental and physical well-being.',
    },
    // Add more trainers here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Our Trainers")),
      body: ListView.builder(
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          final trainer = trainers[index];
          return TrainerCard(
            imageUrl: trainer['imageUrl']!,
            name: trainer['name']!,
            phone: trainer['phone']!,
            location: trainer['location']!,
            bio: trainer['bio']!,
          );
        },
      ),
    );
  }
}
