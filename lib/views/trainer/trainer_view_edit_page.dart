import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_trainer_profile_page.dart'; // You'll create this page next

class TrainerViewEditPage extends StatelessWidget {
  final String trainerId;

  const TrainerViewEditPage({Key? key, required this.trainerId}) : super(key: key);

  Future<DocumentSnapshot> fetchTrainerData() async {
    return await FirebaseFirestore.instance
        .collection('trainers')
        .doc(trainerId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Trainer Profile'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTrainerProfilePage(trainerId: trainerId),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchTrainerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Trainer not found."));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var images = data['imageUrls'] as List<dynamic>? ?? [];
          var name = data['name'] ?? 'Unknown';
          var phone = data['phone'] ?? 'N/A';
          var location = data['location'] ?? 'Not provided';
          var bio = data['AboutYourself'] ?? 'No bio available.';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 220,
                      child: PageView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) => Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade300,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),

                // Card Section
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.phone_android, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(phone, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Text(location, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          "About Trainer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bio,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add logic to contact trainer
                            },
                            icon: const Icon(Icons.message),
                            label: const Text("Contact Trainer"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
