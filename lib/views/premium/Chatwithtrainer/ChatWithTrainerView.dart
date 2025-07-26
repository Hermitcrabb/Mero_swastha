import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'ChatController.dart';
import 'ChatBubble.dart';

class ChatWithTrainerView extends StatefulWidget {
  final String trainerId;

  // Use Get.arguments to get trainerId from navigation
  ChatWithTrainerView({super.key}) : trainerId = Get.arguments['trainerId'];

  @override
  _ChatWithTrainerViewState createState() => _ChatWithTrainerViewState();
}

class _ChatWithTrainerViewState extends State<ChatWithTrainerView> {
  final TextEditingController _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  late Future<bool> isPremiumFuture;
  bool hasSentMessage = false;

  @override
  void initState() {
    super.initState();
    isPremiumFuture = ChatController.checkPremiumStatus(currentUser.uid);
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await ChatController.sendMessage(
      userId: currentUser.uid,
      trainerId: widget.trainerId,
      text: _messageController.text.trim(),
    );

    _messageController.clear();
    setState(() {
      hasSentMessage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Trainer"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<bool>(
        future: isPremiumFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          bool isPremium = snapshot.data!;
          if (!isPremium) {
            return Stack(
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const Center(child: Icon(Icons.lock_outline, size: 100, color: Colors.grey)),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed('/premium'),
                    child: const Text("Unlock with Premium"),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: ChatController.getMessages(currentUser.uid, widget.trainerId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;

                    if (messages.isEmpty && !hasSentMessage) {
                      return const Center(
                        child: Text(
                          "Start a conversation with your trainer!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return ChatBubble(
                          text: msg['text'],
                          isSender: msg['senderId'] == currentUser.uid,
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(hintText: "Type a message..."),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
