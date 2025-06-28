import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart';

class UserController extends GetxController {
  var userModel = Rxn<UserModel>();

  Future<void> fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      userModel.value = UserModel.fromMap(doc.data()!);
    }
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);
      }
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.uid)
        .set(updatedUser.toMap());

    userModel.value = updatedUser;
  }

  void clearUser() {
    userModel.value = null;
  }
}
