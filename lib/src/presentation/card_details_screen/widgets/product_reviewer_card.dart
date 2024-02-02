import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


import '../../../core/core_export.dart';

class ProductReviewerCard extends StatelessWidget {
  const ProductReviewerCard({
    super.key,
    required this.title,
    required this.dateTime,
  });

  final String title;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: Get.textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: SvgPicture.asset(
                  AppIcons.starIcon,
                  width: Sizes.p16,
                  height: Sizes.p16,
                ),
              ),
            ],
          ),
          gapH8,
          Text(
            dateTime,
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppColors.neutral400,
              fontWeight: Fonts.interRegular,
            ),
          ), // January 1, 2023
          gapH8,
          Text(
            'Massa morbi id lorem ultricies. Aliquet eu dolor cras ipsum hendrerit id ut habitant nisi. Lectus ipsum faucibus sed fringilla at tempor.',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppColors.neutral400,
              fontWeight: Fonts.interRegular,
            ),
          ),
          gapH8
        ],
      ),
    );
  }
}
