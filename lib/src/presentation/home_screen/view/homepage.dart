
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habitual/src/presentation/bulk_recharge_screen/view/bulk_recharge.dart';
import 'package:habitual/src/presentation/card_details_screen/view/view_card_details.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/nfc_sessions.dart';
import '../../../common_widgets/toast.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';

import '../../../core/utils/ntag_write.dart';
import '../../../models/write_record.dart';
import '../../categories_screen/widgets/staggered_category_card.dart';
import 'package:get/get.dart';
import 'package:habitual/main.dart';
import 'package:habitual/src/common_widgets/common_widgets_export.dart';

import 'package:habitual/src/methods/auth/firebase_auth.dart';


String greetings(){
  final hour = TimeOfDay.now().hour;

  if(hour <= 12){
    return 'Good Morning!';
  } else if (hour <= 17){
    return 'Good Afternoon!';
  } else if (hour <= 20) {
    return "Good Evening!";
  }

  return 'Good Night!';
}

class TagInvalidateModel with ChangeNotifier{
    // It will invalidate the scanned tag.
    // The card will no longer be supported by our app.

    Future<String?> handleTag(NfcTag tag) async {
      final tech =  Ndef.from(tag);
      final card =  NfcA.from(tag);

      if (tech == null || card == null){
        showToast(message: "Tag is not ndef", type: "error");
        Get.back();
        return "";
      }

      final oldPassword = [0x32, 0x32, 0x32, 0x32]; // Example password
      final pack = [0x00, 0x00, 0x00, 0x00]; // Example pack

      final pwdRemoveCommand = Uint8List.fromList([ 0xA2, 85, 0xFF, 0xFF, 0xFF, 0xFF]); // Page 85 (0x55) for PWD
      final packCommand = Uint8List.fromList([0xA2, 86, ...pack]); // Page 86 (0x56) for PACK

      final bytes = Uint8List.fromList([0x1B, ...oldPassword]);
      try {
        //first authenticating the card to enable write mode
         await card.transceive(data: bytes );
        await Future.delayed(const Duration(milliseconds: 1000));

        //removing password protection and pack
         await card.transceive(data: pwdRemoveCommand );
         await card.transceive(data: packCommand );

        //setting auth0 to the initial size so password authentication successfully removed
        await card.transceive(data: Uint8List.fromList([0xA2, 0x83, 0x02, 0x00, 0x00, 0x86])); //Last byte is AuthLim
        await card.transceive(data: Uint8List.fromList([0xA2, 0x84, 0x00, 0x00, 0x00, 0x00]));

        //Writing a new dummy text to replace existing record of the tag
        NdefRecord ndefRecord = NdefRecord.createText("Hello!");
        NdefMessage message = NdefMessage([ndefRecord]);
        await tech.write(message);

      } on Exception catch(e){
        // print(e);
        showToast(message: "Failed to invalidate tag, Please try again.", type: "error");
      }
      notifyListeners();
      showToast(message: "Tag successfully Invalidated", type: "success");
      return Get.to(() => HomePage());
    }
}

class TagInitiateModel with ChangeNotifier {
  // It will set authentication password and initiate with 0 balance
  // Which will enable using the card with our app.

  Future<String?> handleTag(NfcTag tag) async {
    // this.tag = tag;
    Iterable<WriteRecord> recordList = [];

    final tech = Ndef.from(tag);
    final card = NfcA.from(tag);

    if (tech == null || card == null){
      showToast(message: "Tag is not ndef", type: "error");
      Get.back();
      return "";
    }
    if (!tech.isWritable){
      showToast(message:'Tag is not ndef writable.', type: "error");
      Get.back();
      return "";
    }

    var uid = "";
    var uids = [];
    var recordsToWrite = "" ;
    var initialBalance  = "000000"; //In cents, 6 digit
    uids  = NfcA.from(tag)?.identifier ??
        NfcB.from(tag)?.identifier ??
        NfcF.from(tag)?.identifier ??
        NfcV.from(tag)?.identifier ??
        Uint8List(0);
    uid = uids.join(" ");
    recordsToWrite = "en${String.fromCharCodes(Iterable.castFrom(uids))}$initialBalance";
    // print("records to $recordsToWrite");

    try {
      try{
        // print("text to write : $recordsToWrite" );
        await ntag2xxWriteText(card, recordsToWrite);
      }on Exception catch(e){
        showToast(message: e.toString(), type: "error");
        return e.toString();
      }

      //setting authentication in the ntag215
      final password = [0x32, 0x32, 0x32, 0x32]; // Example password
      final pack = [0x1A, 0x1A, 0x00, 0x00]; // Example pack

      final pwdCommand = Uint8List.fromList([ 0xA2, 85, ...password]); // Page 85 (0x55) for PWD
      final packCommand = Uint8List.fromList([0xA2, 86, ...pack]); // Page 86 (0x56) for PACK

      try {
        await card.transceive(data: packCommand );
        await card.transceive(data: pwdCommand );
        await card.transceive(data: Uint8List.fromList([0xA2, 0x83, 0x02, 0x00, 0x00, 0x04])); //Last byte is AuthLim
        await card.transceive(data: Uint8List.fromList([0xA2, 0x84, 0x00, 0x00, 0x00, 0x00])); //first byte is Access Page:
          // To disable protection
        // nfc.transceive('A2 83 04 00 00 FF')

      } on Exception catch(e){
        showToast(message: "Failed to enable authentication!", type: "error");
      }
    } on PlatformException catch (e) {
      showToast(message: 'Some error has occurred.', type: "error");
      Get.back();
      return "";
      // return e.message ?? 'Some error has occurred.' ;
    }
    notifyListeners();
    showToast(message: "Card Initiated Successfully!", type: "success");
    return Get.to(() => HomePage());
    // return Get.to(CardDetailsScreen());
  }
}


class TagReadModel with ChangeNotifier {
  NfcTag? tag;

  Map<String, dynamic>? additionalData;

  Future<String?> handleTag(NfcTag tag) async {
    this.tag = tag;
    additionalData = {};

    notifyListeners();
    Get.to(() => const CardDetailsScreen());
    return "";
  }
}


class HomePage extends StatelessWidget {
  final user = FirebaseAuthService.instance.getUser();

  static Widget withDependency() => MultiProvider(providers: [
    ChangeNotifierProvider<TagInitiateModel>(
      create: (context) => TagInitiateModel(),
      child: HomePage(),
    ),
    ChangeNotifierProvider<TagReadModel>(
        create: (context) => TagReadModel(),
        child: HomePage(),

        ),
    ChangeNotifierProvider<TagInvalidateModel>(
      create: (context) => TagInvalidateModel(),
      child: HomePage(),

    ),
  ]);


  @override
  Widget build(BuildContext context) {
    final cardButtons = [
      {
        "name" : "Connect Card",
        "onTap" : () => startSession(
          context: context,
          handleTag: Provider.of<TagReadModel>(context, listen: false).handleTag,
        ),
        "icon" : AppAssets.cardInfoIcon,
        "color" : AppColors.blue300
      },
      {
        "name" : "Bulk Recharge",
        "onTap" : () => {
            Get.to(() => const BulkRechargeScreen())
        },
        "icon" : AppAssets.cardRechargeIcon,
        "color" : AppColors.purple300
      },

      {
        "name" : "Initiate Card",
        "onTap" : () => startSession(
          context: context,
          handleTag: (tag) => Provider.of<TagInitiateModel>(context, listen: false).handleTag(tag),
        ),
        "icon" : AppAssets.cardRefillIcon,
        "color" : AppColors.red300
      },
      {
        "name" : "Invalidate Card",
        "onTap" : () => startSession(
          context: context,
          handleTag: (tag) => Provider.of<TagInvalidateModel>(context, listen: false).handleTag(tag),
        ),
        "icon" : AppAssets.cardRemoveIcon,
        "color" : AppColors.green300
      }

    ];

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
                  gapH16,
                  Text(
                    greetings(),
                    style: Get.textTheme.headlineSmall,
                  ),
                  gapH8,
                  Text(
                      "What do you like to do today?",
                      style : Get.textTheme.displayMedium?.copyWith(
                        fontSize: 16
                      ),
                  ),
                  gapH16,
                  gapH16,
                  MasonryGridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisSpacing: Sizes.p16,
                    mainAxisSpacing: Sizes.p16,
                    itemCount: cardButtons.length,
                    gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),

                    itemBuilder: (_, index) => CardButton(
                      color: cardButtons[index]["color"],
                      buttonName: cardButtons[index]["name"],
                      onTap: cardButtons[index]["onTap"],
                      icon: cardButtons[index]["icon"]
                    ),
                  ),
                  gapH24,
                  isNfcAvalible ?
                      const Column(
                        mainAxisSize:  MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        ],
                      )
                  : const Text("NFC Not Available"),
                         // consider: Selector<Tuple<{TAG}, {ADDITIONAL_DATA}>>
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

