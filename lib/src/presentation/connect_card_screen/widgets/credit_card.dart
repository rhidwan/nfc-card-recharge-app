import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:habitual/src/core/constants/app_colors.dart';
import 'package:habitual/src/core/constants/app_sizes.dart';

class CreditCard extends StatelessWidget {
  final Text cardNumber;
  final Text lastRecharge;
  final Text balance;
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
        cardHolderName: '1200',
        cardNumber: '123456789101112',
        obscureCardNumber: false,
        isSwipeGestureEnabled: false,
        expiryDate: '12/2023',
        labelValidThru: 'Date',
        cvvCode: '555',
        bankName: 'Water ATM',
        onCreditCardWidgetChange: (p0) {},

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
