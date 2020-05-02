import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NdefWriteLockModel {
  Future<String> handleTag(NfcTag tag) async {
    final Ndef ndef = Ndef.fromTag(tag);
    if (ndef == null)
      throw('Tag is not ndef.');
    try {
      await ndef.writeLock();
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }
    return '"Ndef - Write Lock" is completed.';
  }
}
