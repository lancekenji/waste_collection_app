import 'package:flutter/material.dart';
import 'views/splash.dart';
import 'views/signup.dart';
import 'views/forgot.dart';
import 'views/about.dart';
import 'views/faq.dart';
import 'views/report.dart';
import 'views/homepage.dart';

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
      home: const HomePageView(),
    );
  }
}
