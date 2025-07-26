import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/auth/login.dart';
import '../views/auth/verify.dart';
import '../views/premium/Chatwithtrainer/ChatWithTrainerView.dart';
import '../views/setup/profile_setup.dart';
import '../views/profile/profile_page.dart';
import '../views/dashboard/dashboard.dart';
import '../views/setup/startup_screen.dart';
import '../views/diet/diet_page.dart';
import '../views/diet/diet_questions.dart';
import '../views/bmi/bmi_page.dart';
import '../views/premium/trainer_list.dart';
import '../views/trainer/trainers_page.dart';
import '../views/auth/trainer_signup.dart';
import '../admin/admin_trainer_approval_page.dart';
import '../views/setup/trainer/trainer_profile_setup_page.dart';
import '../views/setup/trainer/trainer_view_page.dart';




final List<GetPage> appRoutes = [
  GetPage(name: '/startup', page: () => const StartupScreen()),
  GetPage(name: '/login', page: () => const Login()),
  GetPage(name: '/verify', page: () => const Verify()),
  GetPage(name: '/profile_setup', page: () => const ProfileSetupPage()),
  GetPage(name: '/home', page: () => const Dashboard()),
  GetPage(name: '/profile/profile_page', page: () => ProfilePage()),
  GetPage(name: '/diet_questions', page: () => DietQuestions()),
  GetPage(name: '/diet_page', page: () => DietPage()),
  GetPage(name: '/bmi_page', page: () => BmiPage()),
  GetPage(name: '/trainer_list', page: ()=>TrainerListPage()),
  GetPage(name: '/trainer_page', page: ()=>TrainersPage()),
  GetPage(name: '/trainer_signup_page', page: ()=>TrainerSignupPage()),
  GetPage(name: '/admin_trainer_approval_page', page: ()=>AdminTrainerApprovalPage()),
  GetPage(name: '/trainer_profile_setup_page', page: ()=>TrainerProfileSetupPage()),
  GetPage(
    name: '/trainer_view_page',
    page: () {
      final args = Get.arguments;
      if (args == null || !(args is Map<String, dynamic>) || args['trainerId'] == null) {
        return Scaffold(
          body: Center(child: Text('⚠️ Missing trainerId argument')),
        );
      }
      return TrainerViewPage(trainerId: args['trainerId']);
    },
  ),
GetPage(
  name: '/chat_with_trainer_view',
  page: () => ChatWithTrainerView(),
),


];



