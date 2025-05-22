import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/Screens/signup.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgroundsplash1.png"),
            fit: BoxFit.cover

          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 30, // Điều chỉnh vị trí từ trên xuống (thay vì bottom)
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dòng chữ
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Sports",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 36,
                          ),
                        ),
                        TextSpan(
                          text: " Made Simple",
                          style: TextStyle(
                            color: Color(0xff5C5A68),
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24), // Khoảng cách giữa chữ và nút

                  // Nút bấm
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: const StadiumBorder(),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                    ),
                    child: const Text(
                      "Let's Get Started",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}