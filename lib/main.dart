import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/Screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNav App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Splash(),
      routes: {
        //  '/detail': (context) => const DetailScreen(),
      },
    );
  }
}
