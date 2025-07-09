import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/profile/profile_page.dart';  // Import ProfilePage
import 'views/exercise/exercise_page.dart';
import 'views/diet/diet_page.dart';
import 'views/bmi/bmi_page.dart';
import 'views/auth/login.dart';
import 'homeDashboard.dart';
import 'views/models/user_controller.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final UserController userController = Get.find<UserController>(); // Inject controller

  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeDashboard(),
    ProfilePage(),
    ExercisePage(),
    DietPage(),
    BmiPage(),
  ];

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.snackbar("Logged Out", "You have been logged out successfully.",
        snackPosition: SnackPosition.BOTTOM);
    Get.offAll(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Exercise'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_weight), label: 'BMI'),
        ],
      ),
    );
  }
}