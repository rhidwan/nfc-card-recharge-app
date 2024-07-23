
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitual/src/common_widgets/svg_asset.dart';
import 'package:habitual/src/core/constants/app_assets.dart';
import 'package:habitual/src/core/constants/app_fonts.dart';
import 'package:habitual/src/core/constants/app_sizes.dart';

class CardButton extends StatelessWidget {
  final color;
  final  buttonName;
  final  icon;
  final  onTap;

  const CardButton({
    super.key,
    required this.color,
    required this.buttonName,
    required this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: Sizes.deviceWidth * .5,
        padding: const EdgeInsetsDirectional.all(
          Sizes.p16,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Sizes.p10,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgAsset(
                assetPath: icon,
                height: 80,
              ),
            ),
            gapH16,
            Text(
              buttonName,
              style: Get.textTheme.displayLarge?.copyWith(
                fontWeight: Fonts.interRegular,
              )
            )
          ]
        ),
      ),
    );
  }
}


