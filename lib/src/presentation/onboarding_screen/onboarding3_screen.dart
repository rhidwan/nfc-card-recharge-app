import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common_widgets/common_widgets_export.dart';
import '../../core/core_export.dart';
import 'widgets/header_section.dart';

class OnBoarding3Screen extends StatelessWidget {
  const OnBoarding3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: AppDimensions.onboardingScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderSection(
                buttonLabel: 'Exit',
                onPressed: () {},
              ),
              gapH16,
              SvgPicture.asset(
                'assets/images/mailbox.svg',
                width: 342,
                height: 342,
              ),
              Text(
                AppTitles.onboarding3Title,
                style: Get.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              gapH16,
              Text(
                AppTitles.onboarding3Description,
                style: Get.textTheme.displaySmall?.copyWith(
                  color: AppColors.neutral600,
                  fontWeight: AppFonts.interRegular,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              gapH32,
              PrimaryButton(
                buttonLabel: 'Sign me up!',
                buttonColor: AppColors.yellow300,
                labelColor: AppColors.neutral800,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}