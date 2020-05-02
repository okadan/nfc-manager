import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/repository/record.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditUriModel {
  EditUriModel(this.record) {
    if (record == null) return;
    final Map<String, dynamic> data = parseNdefRecord(record.ndefRecord);
    uriController.text = '${data['prefix']}${data['text']}';
  }

  final Record record;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController uriController = TextEditingController();

  Future<void> save() async {
    if (!formKey.currentState.validate())
      throw('form is invalid');
    return RecordRepository.instance.insertOrUpdate(Record(
      id: record?.id,
      ndefRecord: NdefRecord.createUri(Uri.parse(uriController.text)),
    ));
  }
}
