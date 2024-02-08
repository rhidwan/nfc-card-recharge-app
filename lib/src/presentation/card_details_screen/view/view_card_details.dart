import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:habitual/src/common_widgets/custom_divider.dart';
import 'package:habitual/src/common_widgets/nfc_sessions.dart';
import 'package:habitual/src/common_widgets/toast.dart';
import 'package:habitual/src/core/utils/ntag_write.dart';
import 'package:habitual/src/models/record.dart';
import 'package:habitual/src/presentation/card_details_screen/widgets/option_card.dart';
import 'package:habitual/src/routes/app_pages.dart';
import 'package:habitual/src/common_widgets/svg_asset.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/common_widgets_export.dart';
import '../../../core/core_export.dart';
import '../../../models/write_record.dart';
import '../../cart_screen/widgets/cart_product_card.dart';
import 'package:habitual/src/presentation/connect_card_screen/widgets/credit_card.dart';

import '../../tag/read.dart';
class NdefWriteModel with ChangeNotifier {
  // NdefWriteModel();


  Future<String?> handleTag(NfcTag tag, text) async {
    Iterable<WriteRecord> recordList = [];


    var textRecord = WellknownTextRecord(languageCode: "en", text: text);
    recordList = [
      WriteRecord(id: 1, record: textRecord.toNdef())
    ];

    final tech = Ndef.from(tag);
    final card = NfcA.from(tag);

    if (tech == null){
      showToast(message: "Tag is not ndef");
      Get.back();
      return "";
    }
    if (!tech.isWritable){
      showToast(message:'Tag is not ndef writable.');
      Get.back();
      return "";
    }

    try {
      final message = NdefMessage(recordList.map((e) => e.record).toList());
      final bytes = Uint8List.fromList([0x1B, 0x32, 0x32, 0x32, 0x32]);
      try {
        var resp = await card!.transceive(data: bytes );

        print(resp);
        await Future.delayed(const Duration(milliseconds: 1000));
      } on Exception catch(e){
        print(e);
        showToast(message: "Authentication Failed");
      }
      try{
        await ntag2xxWriteText(card, text);
      }on Exception catch(e){
        showToast(message: e.toString());
        return e.toString();
      }
      // try{
      //   await tech.write(message);
      // }on Exception catch(e){
      //   print(e);
      //   showToast(message: e.toString());
      //   return "Something is wrong";
      // }

      

    } on PlatformException catch (e) {
      showToast(message:'Some error has occured.');
      Get.back();
      return "";
      // return e.message ?? 'Some error has occurred.' ;
    }
    notifyListeners();
    showToast(message: "Recharge Successful");
    return Get.to(() => TagReadPage());
    // return Get.to(CardDetailsScreen());
    // return 'Recharge completed';
  }
}

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final currentIndex = 0.obs;

  final pageController = PageController(initialPage: 0);
  var rechargeLoading = false;

  var rechargeAmount = 0;
  var lastRecharge = "";
  var balance = 0;
  var rechargeOptions = [
    200, 300, 500
  ];
  var recordsTowrite = "entestToWriteFromFLUTTER";
  @override
  Widget build(BuildContext context) {
    return Consumer<TagReadModel>(builder: (context, model, _) {
      final tag = model.tag;
      if (tag  == null) {
        return const Text("Invalid Card");
      }
      final uids  = NfcA.from(tag)?.identifier ??
                  NfcB.from(tag)?.identifier ??
                  NfcF.from(tag)?.identifier ??
                  NfcV.from(tag)?.identifier ??
                  Uint8List(0);
      final uid = uids.join(" ");

      final additionalData = model.additionalData;
      print(tag);

    final itemCount = 1.obs;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recharge Card with ',
                      style: Get.textTheme.titleLarge,
                    ),
                    gapH4,
                    // PRICE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //* SELLING PRICE
                            Text(
                              'Tk${rechargeAmount}',
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
                gapW24,
                 PrimaryButton(
                      buttonWidth: 150,
                      buttonHeight: 50,
                      buttonColor: AppColors.neutral800,
                      buttonLabel:   "Recharge",
                      onPressed: () => startSession(context: context,
                        handleTag:(tag) => Provider.of<NdefWriteModel>(context, listen: false).handleTag(tag, recordsTowrite),
                      )

                  )
               ,

              ],
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
                    onPressed: () => Get.offAllNamed(
                      AppRoutes.productDetailsRoute,
                    ),
                  ),
                ),
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

                        gapH16,
                        //* Credit Card
                        const CreditCardEmpty(),

                        gapH8,

                        const CustomDivider(hasText: false),
                        gapH8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'UID',
                              style: Get.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${uid}',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'last Recharge',
                              style: Get.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '12/2023',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance',
                              style: Get.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$79.99',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        const CustomDivider(hasText: false),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recharge',
                              style: Get.textTheme.displayLarge,
                            ),
                            PrimaryTextButton(
                              buttonLabel: "View History",
                              onPressed: () {},
                            ),
                          ],
                        ),

                        gapH8,
                        //* Available Colors
                        SizedBox(
                          height: Sizes.deviceHeight * .15,
                          child: ListView.separated(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_, index) => gapW16,
                            itemBuilder: ( _ , index) => OptionCard(
                              isActive: rechargeOptions[index] == rechargeAmount,
                              amount: rechargeOptions[index],
                              colorName: 'Recharge',
                              onTap: () {
                                setState(() {
                                  rechargeAmount = rechargeAmount == rechargeOptions[index] ?
                                                    0 : rechargeOptions[index] ;
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
  });
}

}