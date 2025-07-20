import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import '../setup/trainer/trainer_view_page.dart';
class TrainerCard extends StatelessWidget {
  final String trainerId; // <-- Add this if you want to fetch details from Firestore
  final String imageUrl;
  final String name;
  final String phone;
  final String location;
  final String bio;

  const TrainerCard({
    super.key,
    required this.trainerId,
    required this.imageUrl,
    required this.name,
    required this.phone,
    required this.location,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TrainerViewPage(trainerId: trainerId),
            ),
          );
        },


      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("📞 $phone"),
                    Text("📍 $location"),
                    const SizedBox(height: 8),
                    Text(
                      bio,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
