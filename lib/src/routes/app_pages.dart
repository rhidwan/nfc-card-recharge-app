import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitual/src/presentation/authentication_screen/view/sign_in_screen.dart';
import 'package:habitual/src/presentation/authentication_screen/view/sign_up_screen.dart';
import 'package:habitual/src/presentation/categories_screen/view/categories_screen.dart';
import 'package:habitual/src/presentation/connect_card_screen/view/checkout_confirmation_screen.dart';
import 'package:habitual/src/presentation/connect_card_screen/view/connect_card.dart';
import 'package:habitual/src/presentation/splash_screen/view/splash_screen.dart';
import 'package:habitual/src/presentation/card_details_screen/view/view_card_details.dart';
import 'package:habitual/src/presentation/registration_screen/view/registration_completed.dart';

import '../presentation/base_screen/base_screen.dart';
import '../presentation/registration_screen/view/registration1_screen.dart';
import '../presentation/registration_screen/view/registration2_screen.dart';
import '../presentation/registration_screen/view/registration3_screen.dart';
import '../presentation/registration_screen/view/registration4_screen.dart';
import '../presentation/registration_screen/view/registration5_screen.dart';

abstract class AppPages {
  static const initial = AppRoutes.introRoute;

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.introRoute,
      page: () => const IntroductionScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    /* 
    * ===== Onboarding Pages =====
     */

    /* 
    * ===== Home Page =====
     */
    GetPage(
      name: AppRoutes.baseRoute,
      page: () => const BaseScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    /* 
    * ===== Product Details Pages =====
     */
    GetPage(
      name: AppRoutes.productDetailsRoute,
      page: () => const CardDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    /* 
    * ===== Payment Pages =====
     */
    GetPage(
      name: AppRoutes.checkoutRoute,
      page: () => const ConnectCardScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.checkoutConfirmationRoute,
      page: () => const CheckoutConfirmationScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    /* 
    * ===== Auth Pages =====
     */
    GetPage(
      name: AppRoutes.signUpRoute,
      page: () => const SignUpScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signInRoute,
      page: () => const SignInScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    /* 
    * ===== Registration Pages =====
     */
    GetPage(
      name: AppRoutes.registration1Route,
      page: () => const Registration1Screen(),
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.registration2Route,
      page: () => const Registration2Screen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.registration3Route,
      page: () => const Registration3Screen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.registration4Route,
      page: () => const Registration4Screen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.registration5Route,
      page: () => const Registration5Screen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.registrationCompleteRoute,
      page: () => const RegistrationCompleted(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.categoriesRoute,
      page: () => const CategoriesScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
  ];
}

abstract class AppRoutes {
  static const introRoute = '/intro';
  static const signInRoute = '/signIn';
  static const signUpRoute = '/signUp';
  static const registration1Route = '/registration1';
  static const registration2Route = '/registration2';
  static const registration3Route = '/registration3';
  static const registration4Route = '/registration4';
  static const registration5Route = '/registration5';
  static const registrationCompleteRoute = '/registrationComplete';
  static const baseRoute = '/';
  static const cartRoute = '/cart';
  static const categoriesRoute = '/categories';
  static const checkoutRoute = '/checkout';
  static const myInterestsRoute = '/myInterests';
  static const editMyInterestsRoute = '/editMyInterests';
  static const checkoutConfirmationRoute = '/checkoutConfirmation';
  static const productDetailsRoute = '/productDetails';
  static const profileRoute = '/profile';
  static const searchRoute = '/search';
  static const wishlistRoute = '/wishlist';
  static const deliveryRoute = '/delivery';
}
