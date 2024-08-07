import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:PureDrop/src/common_widgets/common_widgets_export.dart';
import 'package:PureDrop/src/common_widgets/custom_divider.dart';
import 'package:PureDrop/src/common_widgets/forms/custom_text_field.dart';
import 'package:PureDrop/src/routes/routes_export.dart';

import '../../../core/core_export.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p24,
              Sizes.p24,
              Sizes.p24,
              0,
            ),
            child: Column(
              children: [
                // App Logo
                SvgPicture.asset(
                  AppAssets.appLogoBlack,
                ),
                gapH40,
                Text(
                  'Create account',
                  style: Get.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                gapH16,
                Text(
                  'Find the things that you love!',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral600,
                    fontWeight: Fonts.interRegular,
                  ),
                  textAlign: TextAlign.center,
                ),
                gapH40,
                PrimaryOutlinedButton(
                  hasText: true,
                  title: 'Sign up with Google',
                  onPressed: () {},
                ),
                gapH40,
                const CustomDivider(
                  hasText: true,
                  text: 'or Sign up with Email',
                ),
                gapH40,
                const CustomTextField(
                  labelText: 'Full name',
                  textInputType: TextInputType.text,
                ),
                gapH16,
                const CustomTextField(
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                gapH16,
                const CustomTextField(
                  labelText: 'Password',
                  isSecret: true,
                ),
                gapH40,
                PrimaryButton(
                  buttonColor: AppColors.neutral800,
                  buttonLabel: 'Sign Up',
                  onPressed: () => Get.offAllNamed(
                    AppRoutes.registration2Route,
                  ),
                ),
                gapH24,
                Text.rich(
                  TextSpan(
                    style: Get.textTheme.bodyMedium,
                    text: 'By continuing you accept our standard ',
                    children: const [
                      WidgetSpan(
                        child: Text(
                          'terms and conditions ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          'and our ',
                          style: TextStyle(),
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          'privacy policy.',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                gapH24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Get.textTheme.bodyMedium,
                    ),
                    PrimaryTextButton(
                      defaultTextStyle: false,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                      buttonLabel: 'Log in',
                      onPressed: () => Get.offAndToNamed(
                        AppRoutes.signInRoute,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
