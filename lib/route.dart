
import 'package:get/get.dart';
import 'views/auth/login.dart';
import 'views/auth/verify.dart';
import 'views/setup/profile_setup.dart';
import 'views/profile/profile_page.dart';
import 'homepage.dart';
import 'views/setup/startup_screen.dart';
import 'views/diet/diet_page.dart';
import 'views/diet/diet_questions.dart';
import 'views/bmi/bmi_page.dart';

final List<GetPage> appRoutes = [
  GetPage(name: '/startup', page: () => const StartupScreen()),
  GetPage(name: '/login', page: () => const Login()),
  GetPage(name: '/verify', page: () => const Verify()),
  GetPage(name: '/profile_setup', page: () => const ProfileSetupPage()),
  GetPage(name: '/home', page: () => const Homepage()),
  GetPage(name: '/profile/profile_page', page: () => ProfilePage()),
  GetPage(name: '/diet_questions', page: () => DietQuestions()),
  GetPage(name: '/diet_page', page: () => DietPage()),
  GetPage(name: '/bmi_page', page: () => BmiPage()),
];

