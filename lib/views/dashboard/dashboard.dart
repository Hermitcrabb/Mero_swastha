import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile/profile_page.dart';
import '../exercise/exercise_page.dart';
import '../diet/diet_page.dart';
import '../bmi/bmi_page.dart';
import '../auth/login.dart';
import '../home/home_page.dart';
import '../../models/user/user_controller.dart';
import '../auth/logout.dart';
import '../trainer/trainers_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../setup/trainer/trainer_profile_setup_page.dart';
import '../trainer/trainer_view_edit_page.dart'; // Import view/edit page

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final UserController userController = Get.find<UserController>();

  int _currentIndex = 0;
  bool _isApprovedTrainer = false;
  bool _isCheckingTrainerStatus = true;

  List<Widget> _basePages = [];
  List<BottomNavigationBarItem> _items = [];
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _checkApprovedTrainer();
  }

  Future<void> _checkApprovedTrainer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _updatePagesAndItems(false);
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('trainers').doc(user.uid).get();
    final isApproved = doc.exists;
    _updatePagesAndItems(isApproved);
  }
  void _updatePagesAndItems(bool isApproved) {
    _isApprovedTrainer = isApproved;
    _isCheckingTrainerStatus = false;

    _basePages = [
      const HomePage(),
      ProfilePage(),
      const ExercisePage(),
      const DietPage(),
      const BmiPage(),
      const TrainersPage(),
    ];

    _items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      const BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Exercise'),
      const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Diet'),
      const BottomNavigationBarItem(icon: Icon(Icons.monitor_weight), label: 'BMI'),
      const BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Trainers'),
    ];

    if (_isApprovedTrainer) {
      _basePages.add(_getTrainerPage());
      _items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Trainer Profile',
      ));
    }

    _pages = List<Widget>.from(_basePages);

    if (_currentIndex >= _pages.length) {
      _currentIndex = 0;
    }

    setState(() {});
  }


  Widget _getTrainerPage() {
    final trainerId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('trainers').doc(trainerId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Trainer data does not exist, show setup
          return const TrainerProfileSetupPage();
        }

        final trainerData = snapshot.data!.data() as Map<String, dynamic>;
        final isProfileCompleted = trainerData['profileCompleted'] == true;

        if (isProfileCompleted) {
          return TrainerViewEditPage(trainerId: trainerId);
        } else {
          return const TrainerProfileSetupPage();
        }
      },
    );
  }


  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.snackbar("Logged Out", "You have been logged out successfully.",
        snackPosition: SnackPosition.BOTTOM);
    Get.offAll(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingTrainerStatus) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = userController.userModel.value;
          if (user == null) {
            return const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }
          return Text("Welcome, ${user.name}");
        }),
        actions: [
          LogoutButton(),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _items,
      ),
    );
  }
}
