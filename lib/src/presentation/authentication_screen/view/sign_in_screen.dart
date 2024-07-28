import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:PureDrop/src/methods/auth/firebase_auth.dart';

import '../../../common_widgets/common_widgets_export.dart';
import '../../../common_widgets/forms/custom_text_field.dart';
import '../../../core/core_export.dart';
import '../../../routes/routes_export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
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
                gapH48,
                Image(image: AssetImage(AppAssets.appLogoPrimaryPng),
              height: 100,),
                gapH48,
                Text(
                  'Sign in to your account',
                  style: Get.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),

                gapH40,
                 CustomTextField(
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                gapH16,
                 CustomTextField(
                  labelText: 'Password',
                  isSecret: true,
                  controller: _passwordController,
                ),
                gapH40,
                PrimaryButton(
                  buttonColor: AppColors.neutral800,
                  buttonLabel: _isLoading ? "Loading.." : 'Log in',
                  onPressed: _login,

                ),
                gapH24,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Dont have an account?',
                //       style: Get.textTheme.bodyMedium,
                //     ),
                //     PrimaryTextButton(
                //       defaultTextStyle: false,
                //       style: Get.textTheme.bodyMedium?.copyWith(
                //         decoration: TextDecoration.underline,
                //       ),
                //       buttonLabel: 'Sign up',
                //       onPressed: () => Get.toNamed(
                //         AppRoutes.signUpRoute,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _login() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await FirebaseAuthService.instance.loginWithEmailAndPassword(email, password);
    setState(() {
      _isLoading = false;
    });
  }
}
