import 'package:flutter/material.dart';
import 'package:PureDrop/src/presentation/home_screen/view/homepage.dart';
import '../profile_screen/profile_tab_screen.dart';
import 'widgets/custom_bottom_navbar.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final pageController = PageController();
  final screens = [
    const ProfileTabScreen(),
    // const SearchTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
          screenController: pageController,
        ),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
      ),
    );
  }
}
