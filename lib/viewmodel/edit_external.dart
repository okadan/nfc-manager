import 'dart:convert' show ascii, utf8;

import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/repository/record.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditExternalModel {
  EditExternalModel(this.record) {
    if (record == null) return;
    // final Map<String, dynamic> data = parseNdefRecord(_record.ndefRecord);
    final List<String> splitted = ascii.decode(record.ndefRecord.type).split(":");
    domainController.text = splitted[0];
    typeController.text = splitted[1];
    dataController.text = utf8.decode(record.ndefRecord.payload);
  }

  final Record record;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<void> save() async {
    if (!formKey.currentState.validate())
      throw('form is invalid');
    return RecordRepository.instance.insertOrUpdate(Record(
      id: record?.id,
      ndefRecord: NdefRecord.createExternal(
        domainController.text,
        typeController.text,
        utf8.encode(dataController.text),
      ),
    ));
  }
}
