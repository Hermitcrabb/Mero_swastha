import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/profile/profile_page.dart';  // Import ProfilePage
import 'views/exercise/exercise_page.dart';
import 'views/diet/diet_page.dart';
import 'views/bmi/bmi_page.dart';
import 'views/auth/login.dart';
import 'homeDashboard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 0;

  // Placeholder widgets for each page
  final List<Widget> _pages = [
    HomeDashboard(), // Home Section
    ProfilePage(),   // Profile Section
    ExercisePage(),
    DietPage(),
    BmiPage(),
  ];

  // Logout functionality
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.snackbar("Logged Out", "You have been logged out successfully.",
        snackPosition: SnackPosition.BOTTOM);
    Get.offAll(() => const Login()); // Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mero Swastha"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut, // Logout functionality
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display current page based on bottom nav selection
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
