import 'package:flutter/material.dart';
import 'package:PureDrop/src/common_widgets/svg_asset.dart';

import '../../../core/core_export.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.screenController,
  }) : super(key: key);

  final PageController screenController;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          currentPage = index;
          // widget.screenController.jumpToPage(index);
          widget.screenController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      },
      currentIndex: currentPage,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      unselectedItemColor: AppColors.neutral400,
      unselectedLabelStyle: TextStyle(
        color: AppColors.neutral400,
        fontFamily: Fonts.interFontFamily,
      ),
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: SvgAsset(
            assetPath: AppIcons.homeIcon,
            color:
                currentPage == 0 ? AppColors.neutral900 : AppColors.neutral400,
          ),
          backgroundColor:
              currentPage == 0 ? AppColors.neutral900 : AppColors.neutral400,
        ),

        BottomNavigationBarItem(
          label: 'History',
          icon: SvgAsset(
            assetPath: AppIcons.searchIcon,
            color:
            currentPage == 3 ? AppColors.neutral900 : AppColors.neutral400,
          ),
          backgroundColor:
              currentPage == 2 ? AppColors.neutral900 : AppColors.neutral400,
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: SvgAsset(
            assetPath: AppIcons.profileIcon,
            color:
            currentPage == 2 ? AppColors.neutral900 : AppColors.neutral400,
          ),

          backgroundColor:
              currentPage == 3 ? AppColors.neutral900 : AppColors.neutral400,
        ),
      ],
    );
  }
}
