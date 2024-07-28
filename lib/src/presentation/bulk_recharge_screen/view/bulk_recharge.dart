import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:PureDrop/src/common_widgets/custom_divider.dart';
import 'package:PureDrop/src/common_widgets/nfc_sessions.dart';
import 'package:PureDrop/src/common_widgets/toast.dart';
import 'package:PureDrop/src/core/utils/ntag_write.dart';
import 'package:PureDrop/src/models/record.dart';
import 'package:PureDrop/src/presentation/card_details_screen/widgets/option_card.dart';
import 'package:PureDrop/src/routes/app_pages.dart';
import 'package:PureDrop/src/common_widgets/svg_asset.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/common_widgets_export.dart';
import '../../../core/core_export.dart';
import '../../../methods/auth/firebase_auth.dart';
import '../../../models/write_record.dart';

import 'package:PureDrop/src/presentation/connect_card_screen/widgets/credit_card.dart';

import '../../home_screen/view/homepage.dart';

String getAmountString(int amount){
  // amount will be in 6 digit
  if (amount < 100) return "0000${amount}"; //ex. 99
  if (amount < 1000) return "000${amount}"; //ex. 999
  if (amount < 10000) return "00${amount}"; // ex. 9899
  if (amount < 100000) return "0${amount}"; //ex. 98999
  return "${amount}";

}

class NdefBulkRechargeModel with ChangeNotifier {
  // NdefWriteModel();

  Future<String?> handleTag(NfcTag tag,  bool isRecharge, int amount,) async {
    final tech = await Ndef.from(tag);
    final card = await NfcA.from(tag);

    var currentBalance = 0;

    var uid = "";
    var uids = [];
    var record_to_write = "";
    List card_uid = [];

    if (tech == null){
      showToast(message: "Tag is not ndef", type: "error");
      Get.back();
      return "";
    }
    if (!tech.isWritable){
      showToast(message:'Tag is not ndef writable.', type: "error");
      Get.back();
      return "";
    }

    uids  = NfcA.from(tag)?.identifier ??
        NfcB.from(tag)?.identifier ??
        NfcF.from(tag)?.identifier ??
        NfcV.from(tag)?.identifier ??
        Uint8List(0);
    uid = uids.join(" ");

    final ndef = Ndef.from(tag);
    if (ndef != null && ndef.cachedMessage != null) {
      for (var record in ndef.cachedMessage!.records) {
        try{
          card_uid = record.payload.sublist(3, 10);
        } catch(e){
          print("Card is Invalid");
          showToast(message: "Card Invalid, Please try a valid one", type: "error");
          Get.back();
        }

        // recordsTowrite = recordsTowrite + String.fromCharCodes( record.payload.sublist(3, 10));
        record_to_write = "en" + String.fromCharCodes(Iterable.castFrom(uids));

        if (const ListEquality().equals(card_uid, uids)){
          print("Card is valid");
          String balanceEntry;
          try{
            balanceEntry = String.fromCharCodes(record.payload.sublist(10, 16));
          } catch (e) {
            balanceEntry = "0";
          };
          currentBalance = int.parse(balanceEntry);
          // print("current Balance ${currentBalance}");
        }else{
          // print("Card is Invalid");
          showToast(message: "Card Invalid, Please try a valid one", type: "error");
          Get.back();
        }

      }
    } else {
      // print("Card is invalid");
      showToast(message: "Card Invalid, Please try with a valid one" , type: "error");
    }

    Iterable<WriteRecord> recordList = [];
    var newBalance  = 0;

    if (isRecharge){
      newBalance = currentBalance + amount;
    } else{
      newBalance = amount;
    }
    print("New Balance to add $newBalance");

    var text = record_to_write + getAmountString(newBalance);
    var textRecord = WellknownTextRecord(languageCode: "en", text: text);
    recordList = [
      WriteRecord(id: 1, record: textRecord.toNdef())
    ];


    try {
      final message = NdefMessage(recordList.map((e) => e.record).toList());
      final bytes = Uint8List.fromList([0x1B, 0x32, 0x32, 0x32, 0x32]);
      try {
        var resp = await card!.transceive(data: bytes );

        await Future.delayed(const Duration(milliseconds: 1000));
      } on Exception catch(e){
        showToast(message: "Authentication Failed", type: "error");
      }

      try{
        // print("text to write : $text" );
        await ntag2xxWriteText(card, text);
      }on Exception catch(e){
        showToast(message: e.toString(), type: "error");
        return e.toString();
      }

    } on PlatformException catch (e) {
      showToast(message:'Some error has occurred.', type: "error");
      Get.back();
      return "";
      // return e.message ?? 'Some error has occurred.' ;
    }
    notifyListeners();
    showToast(message: "Recharge Successful", type: "success");
    return Get.to(() => const BulkRechargeScreen());
    // return Get.to(CardDetailsScreen());
    // return 'Recharge completed';
  }
}

class BulkRechargeScreen extends StatefulWidget {
  const BulkRechargeScreen({super.key});

  @override
  State<BulkRechargeScreen> createState() => _BulkRechargeScreenState();
}



class _BulkRechargeScreenState extends State<BulkRechargeScreen> {
  final currentIndex = 0.obs;

  final pageController = PageController(initialPage: 0);
  var rechargeLoading = false;

  var rechargeAmount = 0;
  var lastRecharge = "";
  var balance = 0;
  var uid = "";
  var uids = [];
  List cardUID = [];

  var rechargeOptions = [
    20000, 30000, 50000, 40000 //In cents
  ];
  var recordsToWrite = "" ;

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          bottomNavigationBar: rechargeAmount != 0 ?  AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                SlideTransition(
                  position: Tween(
                    begin: const Offset(0.0, 1.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(animation),
                  child: child,
                ),
            child: Container(
              key: const ValueKey<int>(0),
              padding: const EdgeInsets.fromLTRB(
                Sizes.p24,
                0,
                Sizes.p24,
                0,
              ),
              decoration: BoxDecoration(
                color: AppColors.yellow300,
              ),
              height: Sizes.deviceHeight * .12,
              child: Column(
                  children: [
                    gapH8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Set Balance/Recharge Card with ',
                          style: Get.textTheme.titleLarge,
                        ),
                        // PRICE
                        Row(
                          children: [
                            Row(
                              children: [
                                //* SELLING PRICE
                                Text(
                                  'Tk${rechargeAmount/100}',
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    gapH8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PrimaryOutlinedButton(hasText: true,
                            title: "Set Balance",
                            width: 150,
                            height: 50,
                            onPressed: () => startSession(context: context,
                              handleTag:(tag) => Provider.of<NdefBulkRechargeModel>(context, listen: false).handleTag(tag, false, rechargeAmount),
                            )
                        ),
                        PrimaryButton(
                            buttonWidth: 150,
                            buttonHeight: 41,
                            buttonColor: AppColors.neutral800,
                            buttonLabel:   "Recharge",
                            onPressed: () => startSession(context: context,
                              handleTag:(tag) => Provider.of<NdefBulkRechargeModel>(context, listen: false).handleTag(tag, true, rechargeAmount),
                            )

                        )

                      ],
                    ),

                  ]
              ),
            ),
          ) : null,
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
                  child: Image(
                    image: AssetImage(AppAssets.appLogoPrimaryPng),
                    height: 50,
                  ),
                ),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(
                        right: Sizes.p24,
                      ),
                      child: PrimaryIconButton(
                        icon: AppIcons.logoutIcon,
                        onPressed: () => {
                          FirebaseAuthService.instance.logOut()
                        },
                      )
                  )
                ],
              ),
            ],
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //* Product Image

                    //* Product Title
                    Padding(
                      padding: const EdgeInsets.all(
                        Sizes.p24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CreditCardEmpty(),
                          gapH16,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recharge',
                                style: Get.textTheme.displayLarge,
                              ),
                            ],
                          ),

                          gapH16,
                          //* Available Colors
                          SizedBox(
                            height: Sizes.deviceHeight * .15,
                            child: ListView.separated(
                              itemCount: rechargeOptions.length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, index) => gapW16,
                              itemBuilder: ( _ , index) => OptionCard(
                                isActive: rechargeOptions[index] == rechargeAmount,
                                amount: rechargeOptions[index],
                                colorName: 'Recharge',
                                onTap: () {
                                  setState(() {
                                    rechargeAmount = rechargeAmount == rechargeOptions[index] ?
                                    0 : rechargeOptions[index];

                                  });
                                },
                              ),
                            ),
                          ),
                          gapH32,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

