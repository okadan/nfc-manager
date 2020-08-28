import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class TagReadModel with ChangeNotifier {
  NfcTag tag;
  Map additionalData;

  Future<String> handleTag(NfcTag tag) async {
    this.tag = tag;
    additionalData = {};

    // TODO: more additional data
    if (Platform.isIOS) {
      if (FeliCa.from(tag) != null) {
        final felica = FeliCa.from(tag);
        try {
          additionalData['manufacturerParameter'] = (await felica.polling(
            systemCode: felica.currentSystemCode,
            requestCode: FeliCaPollingRequestCode.noRequest,
            timeSlot: FeliCaPollingTimeSlot.max1,
          )).manufacturerParameter;
        } catch (e) { print('=== $e ==='); return null; } // skip tag discovery
      }
    }

    notifyListeners();
    return '"Tag - Read" is completed.';
  }
}
