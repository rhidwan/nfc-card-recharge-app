import 'package:flutter/material.dart';

import '../../../core/core_export.dart';

class IntroductionScreen extends StatefulWidget {
  final Widget? child;
  const IntroductionScreen({super.key, this.child});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  double divOne = 0;
  double divFive = 0;

  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),(){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: (notify) {
            if (notify is ScrollUpdateNotification) {
              setState(() {
                divOne += notify.scrollDelta! / 1;
                divFive += notify.scrollDelta! / 5;
              });
            }
            return true;
          },
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                primary: true,
                children: [
                  Container(
                    height: Sizes.deviceHeight * 2 - (Sizes.deviceHeight * .80),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      image: const DecorationImage(
                        image:  AssetImage(AppAssets.introductionImage),
                        fit: BoxFit.cover,
                      )
                    ),

                  ),
                ],
              ),
              // Positioned(
              //   left: Sizes.p24,
              //   right: Sizes.p24,
              //   top: Sizes.deviceHeight * .80 - divOne,
              //   child: Column(
              //     children: [
              //       PrimaryButton(
              //         labelColor: AppColors.neutral800,
              //         onPressed: () => Get.toNamed(AppRoutes.signInRoute),
              //         buttonLabel: "Let's begin",
              //         buttonColor: AppColors.yellow300,
              //
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
