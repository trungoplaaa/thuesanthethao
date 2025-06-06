import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thue_san_the_thao_1/Screens/event.dart';
import 'package:thue_san_the_thao_1/Screens/home.dart';
import 'package:thue_san_the_thao_1/Screens/map.dart';
import 'package:thue_san_the_thao_1/Screens/profile.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    EventScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // ✅ Cho phép layout co giãn theo bàn phím
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ✅ Sử dụng bottomNavigationBar thay vì Stack + Align
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff578FCA),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home.svg',
              width: 35,
              height: 35,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ?Color(0xffFBBC05) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/map.svg',
              width: 35,
              height: 35,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Color(0xffFBBC05) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/event.svg',
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Color(0xffFBBC05) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SvgPicture.asset(
                'assets/profile.svg',
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  _currentIndex == 3 ? Color(0xffFBBC05) : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}