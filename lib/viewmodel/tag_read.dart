import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_nfc_manager/_private/felica_extensions.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class TagReadModel {
  final ValueNotifier<Map<String, dynamic>> dataNotifier = ValueNotifier(null);

  Future<String> handleTag(NfcTag tag) async {
    final Map<String, dynamic> data = Map.from(tag.data);

    // TODO: more data
    if (Platform.isIOS) {
      final FeliCa feliCa = FeliCa.fromTag(tag);
      if (feliCa != null) {
        try {
          final FeliCaPollingResponse response = await feliCa.polling();
          data['pmm'] = response.pmm;
        } catch (_) {}
      }
    }

    dataNotifier.value = data;
    return '"Tag - Read" is completed.';
  }
}
