import 'package:flutter/services.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/repository/record.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NdefWriteModel {
  Stream<Iterable<Record>> subscribe() {
    return RecordRepository.instance.getRecordList();
  }

  Future<void> delete(Record record) async {
    return RecordRepository.instance.delete(record);
  }

  Future<String> handleTag(NfcTag tag, Iterable<Record> recordList) async {
    final Ndef ndef = Ndef.fromTag(tag);
    if (ndef == null || !ndef.isWritable)
      throw('Tag is not ndef writable.');
    try {
      final message = NdefMessage(recordList.map((e) => e.ndefRecord).toList());
      await ndef.write(message);
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }
    return '"Ndef - Write" is completed.';
  }
}
