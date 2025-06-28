import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart';
class UserController extends GetxController {
  var userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          userModel.value = UserModel.fromMap(doc.data()!);
        }
      });
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.uid)
        .set(updatedUser.toMap());
    // userModel.value will update automatically via listener
  }

  void clearUser() {
    userModel.value = null;
  }
}
