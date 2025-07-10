import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/models/user_controller.dart';
import 'route.dart'; // your route definitions
import 'package:khalti_flutter/khalti_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inject UserController globally
  Get.put(UserController());

  runApp(
    KhaltiScope(
      publicKey: 'live_public_key_95deacd29e8f4e52b84a5cb18cbc44b9', // use test key for development
      builder: (context, navKey) {
        return GetMaterialApp(
          navigatorKey: navKey,
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
