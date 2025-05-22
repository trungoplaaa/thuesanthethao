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
      body: Stack(

        children:[ IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed ,
                  backgroundColor: const Color(0xff578FCA),
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() => _currentIndex = index),

                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/home.svg',
                        width: 35,
                        height: 35,
                        colorFilter: ColorFilter.mode(
                          _currentIndex == 0 ? Colors.yellow : Colors.white,
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
                          _currentIndex == 1 ? Colors.yellow : Colors.white,
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
                          _currentIndex == 2 ? Colors.yellow : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(top:0.0),
                        child: SvgPicture.asset(
                          'assets/profile.svg',
                          width: 30,
                          height: 30,
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 3 ? Colors.yellow : Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
        ,
      ),

    );
  }
}