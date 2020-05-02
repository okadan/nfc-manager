import 'dart:convert' show ascii, utf8;

import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/repository/record.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditMimeModel {
  EditMimeModel(this.record) {
    if (record == null) return;
    //final Map<String, dynamic> data = parseNdefRecord(record.ndefRecord);
    typeController.text = ascii.decode(record.ndefRecord.type);
    dataController.text = utf8.decode(record.ndefRecord.payload);
  }

  final Record record;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<void> save() async {
    if (!formKey.currentState.validate())
      throw('form is invalid');
    return RecordRepository.instance.insertOrUpdate(Record(
      id: record?.id,
      ndefRecord: NdefRecord.createMime(
        typeController.text,
        utf8.encode(dataController.text),
      ),
    ));
  }
}
