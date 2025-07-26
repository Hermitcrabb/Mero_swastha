import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  static final _firestore = FirebaseFirestore.instance;

  static Future<bool> checkPremiumStatus(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.data()?['isPremium'] ?? false;
  }

  static Stream<QuerySnapshot> getMessages(String userId, String trainerId) {
    String chatId = _generateChatId(userId, trainerId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage({
    required String userId,
    required String trainerId,
    required String text,
  }) async {
    String chatId = _generateChatId(userId, trainerId);

    final message = {
      'senderId': userId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('chats').doc(chatId).set({
      'userId': userId,
      'trainerId': trainerId,
      'lastMessage': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);
  }

  static String _generateChatId(String userId, String trainerId) {
    // Ensures unique but predictable chat ID
    return userId.hashCode <= trainerId.hashCode
        ? '${userId}_$trainerId'
        : '${trainerId}_$userId';
  }
}