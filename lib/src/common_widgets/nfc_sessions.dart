import 'dart:io';

import 'package:flutter/material.dart';
import 'package:PureDrop/src/common_widgets/svg_asset.dart';
import 'package:PureDrop/src/core/constants/app_sizes.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../core/constants/app_assets.dart';

Future<void> startSession({
  required BuildContext context,
  required Future<String?> Function(NfcTag) handleTag,
  String alertMessage = 'Bring your card near the device.',
}) async {
  if (!(await NfcManager.instance.isAvailable())) {
    return showDialog(
      context: context,
      builder: (context) => _UnavailableDialog(),
    );
  }

  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (context) => _AndroidSessionDialog(alertMessage, handleTag),
    );
  }

  if (Platform.isIOS) {
    return NfcManager.instance.startSession(
      alertMessage: alertMessage,
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession(alertMessage: result);
        } catch (e) {
          await NfcManager.instance.stopSession(errorMessage: '$e');
        }
      },
    );
  }
  throw('unsupported platform: ${Platform.operatingSystem}');
}

class _UnavailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const Text('NFC may not be supported or may be temporarily turned off.'),
      actions: [
        TextButton(
          child: const Text('GOT IT'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _AndroidSessionDialog extends StatefulWidget {
  const _AndroidSessionDialog(this.alertMessage, this.handleTag);

  final String alertMessage;

  final Future<String?> Function(NfcTag tag) handleTag;

  @override
  State<StatefulWidget> createState() => _AndroidSessionDialogState();
}

class _AndroidSessionDialogState extends State<_AndroidSessionDialog> {
  String? _alertMessage;
  bool _processing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          setState(() => _processing = true);
          final result = await widget.handleTag(tag);
          setState(()=> _processing = false);
          if (result == null) return;

          setState(() => _alertMessage = result);
          // await NfcManager.instance.stopSession();
        } catch (e) {
          setState(() => _errorMessage = '$e');
          setState(()=> _processing = false);
          await NfcManager.instance.stopSession().catchError((_) { /* no op */ });
        }
      },
    ).catchError((e) {
      // console.log("setting alert message as false")
      setState(() => _errorMessage = '$e');
      setState(()=> _processing = false);
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) { /* no op */ });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          _errorMessage?.isNotEmpty == true ? 'Error' :
          _alertMessage?.isNotEmpty == true ? 'Attention' :
          _processing ? "Processing" :
          'Ready to scan',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
           Center(
             child: _processing ? const Image(
               image: AssetImage(AppAssets.appLogoPrimaryPng),
               height: 100,
             ) : SvgAsset(
               assetPath: AppAssets.cardConnectIcon,
               height: 100,
               color:  _errorMessage?.isNotEmpty == true || _alertMessage?.isNotEmpty == true ?
                        Colors.redAccent : Colors.black,
             ),
           ),
          gapH8,
            Text(
            _errorMessage?.isNotEmpty == true ? _errorMessage! :
            _alertMessage?.isNotEmpty == true ? _alertMessage! :
            _processing ? "We are processing your card." :
            widget.alertMessage,
              style: TextStyle(
                color: _errorMessage?.isNotEmpty == true || _alertMessage?.isNotEmpty == true ?
                          Colors.redAccent : Colors.black
              ),
            )
          ]
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            _errorMessage?.isNotEmpty == true ? 'GOT IT' :
            _alertMessage?.isNotEmpty == true ? 'OK' :
            'CANCEL',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}