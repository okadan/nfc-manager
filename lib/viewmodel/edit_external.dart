import 'dart:convert' show ascii, utf8;

import 'package:app/data/model.dart';
import 'package:app/data/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditExternalModel with ChangeNotifier {
  EditExternalModel(this.oldRecord, this.repo) {
    if (oldRecord == null) return;
    // final Map<String, dynamic> data = parseNdefRecord(oldRecord.ndefRecord);
    final splitted = ascii.decode(oldRecord.ndefRecord.type).split(':');
    domainController.text = splitted[0];
    typeController.text = splitted[1];
    dataController.text = utf8.decode(oldRecord.ndefRecord.payload);
  }

  final Record oldRecord;
  final Repository repo;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<int> save() async {
    if (!formKey.currentState.validate()) return null;
    return repo.upsertRecord(Record.fromNdefRecord(
      id: oldRecord?.id,
      ndefRecord: NdefRecord.createExternal(
        domainController.text,
        typeController.text,
        utf8.encode(dataController.text)),
    ));
  }
}
