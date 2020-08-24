import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NdefWriteLockModel with ChangeNotifier {
  Future<String> handleTag(NfcTag tag) async {
    final tech = Ndef.from(tag);
    if (tech == null)
      throw('Tag is not compatible with NDEF.');

    try {
      await tech.writeLock();
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }

    return '"Ndef - Write Lock" is completed.';
  }
}
