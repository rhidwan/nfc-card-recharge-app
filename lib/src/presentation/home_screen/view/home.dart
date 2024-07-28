import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PureDrop/main.dart';
import 'package:PureDrop/src/common_widgets/common_widgets_export.dart';
import 'package:PureDrop/src/common_widgets/custom_divider.dart';
import 'package:PureDrop/src/methods/auth/firebase_auth.dart';
import 'package:PureDrop/src/presentation/connect_card_screen/widgets/credit_card.dart';

import 'package:PureDrop/src/routes/app_pages.dart';
import 'package:PureDrop/src/common_widgets/svg_asset.dart';

import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:PureDrop/src/core/utils/extensions.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/form_row.dart';
import '../../../common_widgets/nfc_sessions.dart';
import '../../../core/core_export.dart';
import '../../tag/ndef_record.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = FirebaseAuthService.instance.getUser();

  ValueNotifier<dynamic> result = ValueNotifier(null);

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
                      FirebaseAuthService.instance.logOut()
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
                        "Welcome",
                        style: Get.textTheme.displayLarge,
                      ),
                    ],
                  ),
                  gapH8,
                  Text("${user.email}",
                    style: Get.textTheme.bodyMedium,
                  ),
                  gapH16,
                  //* Credit Card
                  const CreditCardEmpty(),
                  gapH24,
                  isNfcAvalible ?
                  PrimaryButton(
                    buttonColor: AppColors.neutral800,
                    buttonLabel: 'Connect Card',
                    onPressed: () async {
                      bool isAvailable = await NfcManager.instance.isAvailable();
                      if (isAvailable == false) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: SizedBox(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('TURN ON NFC !')
                                        ],
                                      )));
                            });
                      } else {
                        NfcManager.instance.startSession(
                            onDiscovered: (NfcTag tag) {
                              // info.mark(_auth.firebaseAuth.currentUser.uid,
                              //     tag.data['isodep']['identifier'][0]);
                              print(tag.data);
                              if (Navigator.of(context).canPop() == true) {
                                Navigator.pop(context);
                                NfcManager.instance.stopSession();
                              }
                              return Future(() => tag.data);
                            });
                        return showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: SizedBox(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.nfc, size: 50),
                                          SizedBox(height: 10),
                                          Text('Reading NFC')
                                        ],
                                      )));
                            });
                      }
                    },
                    // onPressed: () => Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) => TagReadPage.withDependency(),
                    // )),
                  ) : Text("NFC Not Available"),
                  gapH16,
                  // consider: Selector<Tuple<{TAG}, {ADDITIONAL_DATA}>>

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}