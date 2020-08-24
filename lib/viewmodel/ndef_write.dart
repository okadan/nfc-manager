import 'package:app/data/model.dart';
import 'package:app/data/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NdefWriteModel with ChangeNotifier {
  NdefWriteModel(this.repo);

  final Repository repo;

  Stream<Iterable<Record>> subscribe() {
    return repo.subscribeRecordList();
  }

  Future<void> delete(Record record) async {
    return repo.deleteRecord(record.id);
  }

  Future<String> handleTag(NfcTag tag, Iterable<Record> recordList) async {
    final tech = Ndef.from(tag);
    if (tech == null)
      throw('Tag is not compatible with NDEF.');
    if (!tech.isWritable)
      throw('Tag is not NDEF writable.');

    try {
      await tech.write(NdefMessage(recordList.map((e) => e.ndefRecord).toList()));
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }

    return '"Ndef - Write" is completed.';
  }
}
