import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'trainer_card.dart';
import '../../models/trainer_model/trainer_model.dart';

class TrainersPage extends StatelessWidget {
  const TrainersPage({super.key});

  Future<List<TrainerModel>> fetchTrainers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('trainers')
        .get();

    return querySnapshot.docs.map((doc) {
      return TrainerModel.fromMap(doc.data());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Our Trainers")),
      body: FutureBuilder<List<TrainerModel>>(
        future: fetchTrainers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No trainers found."));
          }

          final trainers = snapshot.data!;
          return ListView.builder(
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              final trainer = trainers[index];
              return TrainerCard(
                trainerId: trainer.uid,
                imageUrl: trainer.photoUrl,
                name: trainer.name,
                phone: trainer.phone,
                location: trainer.location,
                bio: trainer.bio,
              );
            },
          );
        },
      ),
    );
  }
}
