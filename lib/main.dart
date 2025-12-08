import 'package:flutter/material.dart';
import 'views/homepage.dart';
import 'views/login.dart';
import 'views/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Collection System',
      theme: ThemeData.light(),
      home: const SplashView(),
      initialRoute: "/splash",
      routes: {
        '/login': (context) => const LoginView(),
        '/splash': (context) => const SplashView(),
        '/homepage': (context) => const HomePageView(),
      },
    );
  }
}
