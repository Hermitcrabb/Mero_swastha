import 'package:flutter/material.dart';

class TrainerListPage extends StatelessWidget {
  const TrainerListPage({super.key});

  final List<Map<String, String>> mockTrainers = const [
    {
      'name': 'Ryo Takeda',
      'shortBio': 'Strength & Conditioning expert from Lopium.',
      'profilePicture': 'https://i.imgur.com/BoN9kdC.png'
    },
    {
      'name': 'Sakura Min',
      'shortBio': 'Yoga and flexibility trainer, known for balance routines.',
      'profilePicture': 'https://i.imgur.com/jNNT4LE.jpg'
    },
    {
      'name': 'Daisuke Mori',
      'shortBio': 'Focuses on calisthenics and mental endurance.',
      'profilePicture': 'https://i.imgur.com/WzJdS8z.jpg'
    },
    {
      'name': 'Aiko Ren',
      'shortBio': 'Expert in HIIT and metabolic training.',
      'profilePicture': 'https://i.imgur.com/sBJJ9yM.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Trainers'),
      ),
      body: ListView.builder(
        itemCount: mockTrainers.length,
        itemBuilder: (context, index) {
          final trainer = mockTrainers[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(trainer['profilePicture']!),
              ),
              title: Text(
                trainer['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(trainer['shortBio']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // You can add navigation to detail page here
              },
            ),
          );
        },
      ),
    );
  }
}


