import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:habitual/src/core/constants/app_assets.dart';
import 'package:habitual/src/core/constants/app_colors.dart';
import 'package:habitual/src/core/constants/app_sizes.dart';

class CreditCard extends StatelessWidget {
  final String cardNumber;
  final String lastRecharge;
  final String balance;
  const CreditCard({super.key, required this.cardNumber, required this.lastRecharge, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.p10,
        ),
      ),
      child: CreditCardWidget(
        showBackView: false,
        isHolderNameVisible: true,
        obscureCardCvv: false,
        isChipVisible: true,
        cardBgColor: AppColors.neutral900,
        labelCardHolder: 'Card',
        cardHolderName: '${balance}',
        cardNumber: '${cardNumber}',
        obscureCardNumber: false,
        isSwipeGestureEnabled: false,
        expiryDate: '12/26',
        labelValidThru: '',
        cvvCode: '555',
        chipColor: Colors.amberAccent,
        bankName: 'Water ATM',
        cardType: CardType.mastercard,
        onCreditCardWidgetChange: (p0) {},
        customCardTypeIcons: [
         CustomCardTypeIcon(cardType: CardType.mastercard, cardImage: Image.asset(AppAssets.appLogoPrimaryPng, height: 40, width: 40,))
        ],
      ),
    );
  }
}

class CreditCardEmpty extends StatelessWidget {

  const CreditCardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.p10,
        ),
      ),
      child: CreditCardWidget(
        showBackView: false,
        isHolderNameVisible: true,
        obscureCardCvv: false,
        isChipVisible: false,
        cardBgColor: AppColors.neutral400,
        labelCardHolder: 'Card',
        cardHolderName: 'Connect Card',
        cardNumber: '0000 0000 0000',
        obscureCardNumber: false,
        obscureInitialCardNumber: true,
        isSwipeGestureEnabled: false,
        expiryDate: '00/00',
        labelValidThru: '',
        cvvCode: '',
        bankName: 'Water ATM',
        onCreditCardWidgetChange: (p0) {},

      ),
    );
  }
}
