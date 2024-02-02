import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitual/src/common_widgets/common_widgets_export.dart';
import 'package:habitual/src/common_widgets/custom_divider.dart';
import 'package:habitual/src/methods/auth/firebase_auth.dart';
import 'package:habitual/src/presentation/connect_card_screen/widgets/credit_card.dart';
import 'package:habitual/src/routes/app_pages.dart';
import 'package:habitual/src/common_widgets/svg_asset.dart';

import '../../../core/core_export.dart';

class ConnectCardScreen extends StatefulWidget {

  const ConnectCardScreen({super.key});

  @override
  State<ConnectCardScreen> createState() => _ConnectCardScreenState();
}

class _ConnectCardScreenState extends State<ConnectCardScreen> {
  var user = FirebaseAuthService.instance.getUser();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          [
            SliverAppBar(
              leading: const Padding(
                padding: EdgeInsets.only(
                  left: Sizes.p24,
                  top: Sizes.p16,
                  bottom: Sizes.p16,
                ),
                child: SvgAsset(
                  assetPath: AppAssets.appLogoBlackSmall,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: Sizes.p24,
                  ),
                  child: PrimaryIconButton(
                    icon: AppIcons.shoppingCartIcon,
                    onPressed: () => {
                      FirebaseAuthService.instance.logOut();
                    },
                  ),
                ),
              ],
            ),
          ],
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome ${user.email}",
                        style: Get.textTheme.displayLarge,
                      ),

                    ],
                  ),
                  gapH16,
                  //* Credit Card
                  const CreditCard(),
                  gapH24,

                  PrimaryButton(
                    buttonColor: AppColors.neutral800,
                    buttonLabel: 'Connect Card',
                    onPressed: () => Get.offAllNamed(
                      AppRoutes.productDetailsRoute,
                    ),
                  ),
                  gapH16,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
