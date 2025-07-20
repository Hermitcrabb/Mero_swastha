import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'trainer_model.dart';

class TrainerController extends GetxController {
  var trainerModel = Rxn<TrainerModel>();

  @override
  void onInit() {
    super.onInit();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('trainers')
          .doc(uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          trainerModel.value = TrainerModel.fromMap(doc.data()!);
        }
      });
    }
  }

  Future<void> loadTrainer() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('trainers').doc(uid).get();
    if (doc.exists) {
      trainerModel.value = TrainerModel.fromMap(doc.data()!);
    } else {
      trainerModel.value = null;
    }
  }

  Future<void> updateTrainer(TrainerModel updatedTrainer) async {
    await FirebaseFirestore.instance
        .collection('trainers')
        .doc(updatedTrainer.uid)
        .set(updatedTrainer.toMap());
    // trainerModel.value will update automatically via listener
  }

  void clearTrainer() {
    trainerModel.value = null;
  }
}
