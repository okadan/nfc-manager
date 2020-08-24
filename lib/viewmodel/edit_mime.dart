import 'dart:convert' show ascii, utf8;

import 'package:app/data/model.dart';
import 'package:app/data/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditMimeModel with ChangeNotifier {
  EditMimeModel(this.oldRecord, this.repo) {
    if (oldRecord == null) return;
    //final Map<String, dynamic> data = parseNdefRecord(oldRecord.ndefRecord);
    typeController.text = ascii.decode(oldRecord.ndefRecord.type);
    dataController.text = utf8.decode(oldRecord.ndefRecord.payload);
  }

  final Record oldRecord;
  final Repository repo;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<int> save() async {
    if (!formKey.currentState.validate()) return null;
    return repo.upsertRecord(Record.fromNdefRecord(
      id: oldRecord?.id,
      ndefRecord: NdefRecord.createMime(
        typeController.text,
        utf8.encode(dataController.text),
      ),
    ));
  }
}
