import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core_export.dart';

// import '../../../core/constants/app_colors.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    Key? key,
    required this.isActive,
    required this.onTap,
    required this.amount,

    required this.colorName,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback? onTap;
  final String colorName;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.deviceWidth * .30,
      height: Sizes.deviceHeight * .5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.p10),
        border: Border.all(
          color: isActive ? AppColors.yellow300 : AppColors.neutral600,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          Sizes.p10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(Sizes.p12),
                height: 42,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.yellow100 : Colors.transparent,
                ),
                child: Text(
                  colorName,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              gapH12,
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.p12,
                  0,
                  Sizes.p12,
                  Sizes.p12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\Tk${amount}',
                      style: Get.textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
