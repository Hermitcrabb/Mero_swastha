import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/models/user_controller.dart';
import 'route.dart'; // ✅ make sure this exports your `appRoutes`
import 'views/setup/startup_screen.dart'; // wherever your StartupScreen is
import 'package:khalti_flutter/khalti_flutter.dart';
import 'homepage.dart'; // or wherever your initial screen is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inject the UserController globally using GetX
  Get.put(UserController());

  runApp(
    KhaltiScope(
      publicKey: 'test_public_key_xxx', // replace with your Khalti test or live public key
      builder: (context, navKey) {
        return GetMaterialApp(
          navigatorKey: navKey, // ✨ Required for Khalti navigation
          debugShowCheckedModeBanner: false,
          title: 'Mero Swastha',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          initialRoute: '/login',
          getPages: appRoutes,
        );
      },
    ),
  );
}

class MeroSwastha extends StatelessWidget {
  const MeroSwastha({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mero Swastha',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),

      // ✅ Use GetX routing system
      initialRoute: '/login',
      getPages: appRoutes, // ✅ from route.dart
    );
  }
}
