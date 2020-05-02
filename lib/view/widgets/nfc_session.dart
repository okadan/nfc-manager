import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> startTagSession({
  @required BuildContext context,
  @required Future<String> Function(NfcTag) handleTag,
  String alertMessage = 'Hold your device near the item.',
}) async {
  if (Platform.isIOS) {
    return NfcManager.instance.startTagSession(
      alertMessageIOS: alertMessage,
      onDiscovered: (tag) async {
        try {
          final String result = await handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession(alertMessageIOS: result);
        } catch (e) {
          await NfcManager.instance.stopSession(errorMessageIOS: '$e');
        }
      },
    );
  }
  return showDialog(
    context: context,
    builder: (context) => _AndroidNfcDialog(
      alertMessage: alertMessage,
      handleTag: handleTag,
    ),
  );
}

class _AndroidNfcDialog extends StatefulWidget {
  _AndroidNfcDialog({ @required this.handleTag, @required this.alertMessage });

  final String alertMessage;

  final Future<String> Function(NfcTag tag) handleTag;

  @override
  State<StatefulWidget> createState() => _AndroidNfcDialogState();
}

class _AndroidNfcDialogState extends State<_AndroidNfcDialog> {
  String _alertMessage;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startTagSession(
      onDiscovered: (tag) async {
        try {
          final String result = await widget.handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession();
          setState(() => _alertMessage = result);
        } catch (e) {
          await NfcManager.instance.stopSession();
          setState(() => _errorMessage = '$e');
        }
      },
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _errorMessage?.isNotEmpty == true ? 'Error' :
        _alertMessage?.isNotEmpty == true ? 'Success' :
        'Ready to scan',
      ),
      content: Text(
        _errorMessage?.isNotEmpty == true ? _errorMessage :
        _alertMessage?.isNotEmpty == true ? _alertMessage :
        widget.alertMessage,
      ),
      actions: [
        FlatButton(
          child: Text(
            _errorMessage?.isNotEmpty == true ? 'Got it' :
            _alertMessage?.isNotEmpty == true ? 'OK' :
            'Cancel',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
