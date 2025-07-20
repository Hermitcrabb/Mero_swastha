import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'views/models/user_controller.dart';
import 'route.dart';

class MeroSwasthaApp extends StatelessWidget {
  const MeroSwasthaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_dc74b3be763f481f9fbc87cf51484974', // use test key for testing
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
    );
  }
}
