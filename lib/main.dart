import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thue_san_the_thao_1/Screens/home.dart';
import 'package:thue_san_the_thao_1/Screens/splash.dart';
import 'package:thue_san_the_thao_1/Screens/signin.dart';
import 'package:thue_san_the_thao_1/mainscreen.dart';
import 'package:thue_san_the_thao_1/widget/change_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  runApp(MyApp(
    isLoggedIn: token != null,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thue San The Thao',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const MainScreen() : const Splash(),
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
      },
    );
  }
}
