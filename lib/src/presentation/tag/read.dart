import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:habitual/src/core/utils/extensions.dart';
import 'package:habitual/src/presentation/card_details_screen/view/view_card_details.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';


import '../../common_widgets/buttons/primary_button.dart';
import '../../common_widgets/form_row.dart';
import '../../common_widgets/nfc_sessions.dart';
import '../../common_widgets/svg_asset.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_sizes.dart';

import 'ndef_record.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitual/main.dart';
import 'package:habitual/src/common_widgets/common_widgets_export.dart';
import 'package:habitual/src/common_widgets/custom_divider.dart';
import 'package:habitual/src/methods/auth/firebase_auth.dart';
import 'package:habitual/src/presentation/connect_card_screen/widgets/credit_card.dart';



class TagReadModel with ChangeNotifier {
  NfcTag? tag;

  Map<String, dynamic>? additionalData;

  Future<String?> handleTag(NfcTag tag) async {
    this.tag = tag;
    additionalData = {};

    Object? tech;

    // todo: more additional data
    if (Platform.isIOS) {
      tech = FeliCa.from(tag);
      if (tech is FeliCa) {
        final polling = await tech.polling(
          systemCode: tech.currentSystemCode,
          requestCode: FeliCaPollingRequestCode.noRequest,
          timeSlot: FeliCaPollingTimeSlot.max1,
        );
        additionalData!['manufacturerParameter'] = polling.manufacturerParameter;
      }
    }

    notifyListeners();
    return Get.to(CardDetailsScreen());
    // return '[Tag - Read] is completed.';
  }
}

class TagReadPage extends StatelessWidget {
  static Widget withDependency() => ChangeNotifierProvider<TagReadModel>(
    create: (context) => TagReadModel(),
    child: TagReadPage(),

  );
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
                  Text("iqbal",
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
                    onPressed: () => startSession(
                      context: context,
                      handleTag: Provider.of<TagReadModel>(context, listen: false).handleTag,
                    ),
                    // onPressed: () => Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) => TagReadPage.withDependency(),
                    // )),
                  ) : Text("NFC Not Available"),
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



class _TagInfo extends StatelessWidget {
  _TagInfo(this.tag, this.additionalData);

  final NfcTag tag;

  final Map<String, dynamic> additionalData;

  @override
  Widget build(BuildContext context) {
    final tagWidgets = <Widget>[];
    final ndefWidgets = <Widget>[];

    Object? tech;

    if (Platform.isAndroid) {
      tagWidgets.add(FormRow(
        title: Text('Identifier'),
        subtitle: Text('${(
            NfcA
                .from(tag)
                ?.identifier ??
                NfcB
                    .from(tag)
                    ?.identifier ??
                NfcF
                    .from(tag)
                    ?.identifier ??
                NfcV
                    .from(tag)
                    ?.identifier ??
                Uint8List(0)
        ).join(" ")}'),
      ));
      //   tagWidgets.add(FormRow(
      //     title: Text('Tech List'),
      //     subtitle: Text(_getTechListString(tag)),
      //   ));
      //   tagWidgets.add(FormRow(
      //     title: Text('Data'),
      //     subtitle: Text("${tag.data}"),
      //   ));
      //   tech = NfcA.from(tag);
      //   if (tech is NfcA) {
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcA - Atqa'),
      //       subtitle: Text('${tech.atqa.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcA - Sak'),
      //       subtitle: Text('${tech.sak}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcA - Max Transceive Length'),
      //       subtitle: Text('${tech.maxTransceiveLength}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcA - Timeout'),
      //       subtitle: Text('${tech.timeout}'),
      //     ));
      //
      //     tech = MifareClassic.from(tag);
      //     if (tech is MifareClassic) {
      //
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareClassic - Type'),
      //         subtitle: Text(_getMiFareClassicTypeString(tech.type)),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareClassic - Size'),
      //         subtitle: Text('${tech.size}'),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareClassic - Sector Count'),
      //         subtitle: Text('${tech.sectorCount}'),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareClassic - Block Count'),
      //         subtitle: Text('${tech.blockCount}'),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareClassic - Max Transceive Length'),
      //         subtitle: Text('${tech.maxTransceiveLength}'),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareClassic - Timeout'),
      //         subtitle: Text('${tech.timeout}'),
      //       ));
      //     }
      //
      //     tech = MifareUltralight.from(tag);
      //     if (tech is MifareUltralight) {
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareUltralight - Type'),
      //         subtitle: Text(_getMiFareUltralightTypeString(tech.type)),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareUltralight - Max Transceive Length'),
      //         subtitle: Text('${tech.maxTransceiveLength}'),
      //       ));
      //       tagWidgets.add(FormRow(
      //         title: Text('MifareUltralight - Timeout'),
      //         subtitle: Text('${tech.timeout}'),
      //       ));
      //     }
      //   }
      //
      //   tech = NfcB.from(tag);
      //   if (tech is NfcB) {
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcB - Application Data'),
      //       subtitle: Text('${tech.applicationData.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcB - Protocol Info'),
      //       subtitle: Text('${tech.protocolInfo.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcB - Max Transceive Length'),
      //       subtitle: Text('${tech.maxTransceiveLength}'),
      //     ));
      //   }
      //
      //   tech = NfcF.from(tag);
      //   if (tech is NfcF) {
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcF - System Code'),
      //       subtitle: Text('${tech.systemCode.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcF - Manufacturer'),
      //       subtitle: Text('${tech.manufacturer.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcF - Max Transceive Length'),
      //       subtitle: Text('${tech.maxTransceiveLength}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcF - Timeout'),
      //       subtitle: Text('${tech.timeout}'),
      //     ));
      //   }
      //
      //   tech = NfcV.from(tag);
      //   if (tech is NfcV) {
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcV - DsfId'),
      //       subtitle: Text('${tech.dsfId}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcV - Response Flags'),
      //       subtitle: Text('${tech.responseFlags}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('NfcV - Max Transceive Length'),
      //       subtitle: Text('${tech.maxTransceiveLength}'),
      //     ));
      //   }
      //
      //   tech = IsoDep.from(tag);
      //   if (tech is IsoDep) {
      //     tagWidgets.add(FormRow(
      //       title: Text('IsoDep - Hi Layer Response'),
      //       subtitle: Text('${tech.hiLayerResponse?.toHexString() ?? '-'}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('IsoDep - Historical Bytes'),
      //       subtitle: Text('${tech.historicalBytes?.toHexString() ?? '-'}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('IsoDep - Extended Length Apdu Supported'),
      //       subtitle: Text('${tech.isExtendedLengthApduSupported}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('IsoDep - Max Transceive Length'),
      //       subtitle: Text('${tech.maxTransceiveLength}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('IsoDep - Timeout'),
      //       subtitle: Text('${tech.timeout}'),
      //     ));
      //   }
      // }
      //
      // if (Platform.isIOS) {
      //   tech = FeliCa.from(tag);
      //   if (tech is FeliCa) {
      //     final manufacturerParameter = additionalData['manufacturerParameter'] as Uint8List?;
      //     tagWidgets.add(FormRow(
      //       title: Text('Type'),
      //       subtitle: Text('FeliCa'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Current IDm'),
      //       subtitle: Text('${tech.currentIDm.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Current System Code'),
      //       subtitle: Text('${tech.currentSystemCode.toHexString()}'),
      //     ));
      //     if (manufacturerParameter != null)
      //       tagWidgets.add(FormRow(
      //         title: Text('Manufacturer Parameter'),
      //         subtitle: Text('${manufacturerParameter.toHexString()}'),
      //       ));
      //   }
      //
      //   tech = Iso15693.from(tag);
      //   if (tech is Iso15693) {
      //     tagWidgets.add(FormRow(
      //       title: Text('Type'),
      //       subtitle: Text('ISO15693'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Identifier'),
      //       subtitle: Text('${tech.identifier.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('IC Serial Number'),
      //       subtitle: Text('${tech.icSerialNumber.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('IC Manufacturer Code'),
      //       subtitle: Text('${tech.icManufacturerCode}'),
      //     ));
      //   }
      //
      //   tech = Iso7816.from(tag);
      //   if (tech is Iso7816) {
      //     tagWidgets.add(FormRow(
      //       title: Text('Type'),
      //       subtitle: Text('ISO7816'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Identifier'),
      //       subtitle: Text('${tech.identifier.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Initial Selected AID'),
      //       subtitle: Text('${tech.initialSelectedAID}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Application Data'),
      //       subtitle: Text('${tech.applicationData?.toHexString() ?? '-'}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Historical Bytes'),
      //       subtitle: Text('${tech.historicalBytes?.toHexString() ?? '-'}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Proprietary Application Data Coding'),
      //       subtitle: Text('${tech.proprietaryApplicationDataCoding}'),
      //     ));
      //   }
      //
      //   tech = MiFare.from(tag);
      //   if (tech is MiFare) {
      //     tagWidgets.add(FormRow(
      //       title: Text('Type'),
      //       subtitle: Text('MiFare ' + _getMiFareFamilyString(tech.mifareFamily)),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Identifier'),
      //       subtitle: Text('${tech.identifier.toHexString()}'),
      //     ));
      //     tagWidgets.add(FormRow(
      //       title: Text('Historical Bytes'),
      //       subtitle: Text('${tech.historicalBytes?.toHexString() ?? '-'}'),
      //     ));
    }


    tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;
      final canMakeReadOnly = tech.additionalData['canMakeReadOnly'] as bool?;
      final type = tech.additionalData['type'] as String?;
      if (type != null)
        // ndefWidgets.add(FormRow(
        //   title: Text('Type'),
        //   subtitle: Text(_getNdefType(type)),
        // ));
      // ndefWidgets.add(FormRow(
      //   title: Text('Size'),
      //   subtitle: Text('${cachedMessage?.byteLength ?? 0} / ${tech.maxSize} bytes'),
      // ));
      // ndefWidgets.add(FormRow(
      //   title: Text('Writable'),
      //   subtitle: Text('${tech.isWritable}'),
      // ));
      // if (canMakeReadOnly != null)
      //   ndefWidgets.add(FormRow(
      //     title: Text('Can Make Read Only'),
      //     subtitle: Text('$canMakeReadOnly'),
      //   ));
      if (cachedMessage != null)
        Iterable.generate(cachedMessage.records.length).forEach((i) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);
          ndefWidgets.add(FormRow(
            title: Text('#$i ${info.title}'),
            subtitle: Text('${info.subtitle}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => NdefRecordPage(i, record),
            )),
          ));
        });
    }

    return Column(
      children: [
        FormSection(
          header: Text('TAG'),
          children: tagWidgets,
        ),
        if (ndefWidgets.isNotEmpty)
          FormSection(
            header: Text('NDEF'),
            children: ndefWidgets,
          ),
      ],
    );
  }
}

String _getTechListString(NfcTag tag) {
  final techList = <String>[];
  if (tag.data.containsKey('nfca'))
    techList.add('NfcA');
  if (tag.data.containsKey('nfcb'))
    techList.add('NfcB');
  if (tag.data.containsKey('nfcf'))
    techList.add('NfcF');
  if (tag.data.containsKey('nfcv'))
    techList.add('NfcV');
  if (tag.data.containsKey('isodep'))
    techList.add('IsoDep');
  if (tag.data.containsKey('mifareclassic'))
    techList.add('MifareClassic');
  if (tag.data.containsKey('mifareultralight'))
    techList.add('MifareUltralight');
  if (tag.data.containsKey('ndef'))
    techList.add('Ndef');
  if (tag.data.containsKey('ndefformatable'))
    techList.add('NdefFormatable');
  return techList.join(' / ');
}

String _getMiFareClassicTypeString(int code) {
  switch (code) {
    case 0:
      return 'Classic';
    case 1:
      return 'Plus';
    case 2:
      return 'Pro';
    default:
      return 'Unknown';
  }
}

String _getMiFareUltralightTypeString(int code) {
  switch (code) {
    case 1:
      return 'Ultralight';
    case 2:
      return 'Ultralight C';
    default:
      return 'Unknown';
  }
}

String _getMiFareFamilyString(MiFareFamily family) {
  switch (family) {
    case MiFareFamily.unknown:
      return 'Unknown';
    case MiFareFamily.ultralight:
      return 'Ultralight';
    case MiFareFamily.plus:
      return 'Plus';
    case MiFareFamily.desfire:
      return 'Desfire';
    default:
      return 'Unknown';
  }
}

String _getNdefType(String code) {
  switch (code) {
    case 'org.nfcforum.ndef.type1':
      return 'NFC Forum Tag Type 1';
    case 'org.nfcforum.ndef.type2':
      return 'NFC Forum Tag Type 2';
    case 'org.nfcforum.ndef.type3':
      return 'NFC Forum Tag Type 3';
    case 'org.nfcforum.ndef.type4':
      return 'NFC Forum Tag Type 4';
    default:
      return 'Unknown';
  }
}