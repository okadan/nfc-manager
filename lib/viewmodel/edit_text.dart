import 'package:app/data/model.dart';
import 'package:app/data/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditTextModel with ChangeNotifier {
  EditTextModel(this.oldRecord, this.repo) {
    if (oldRecord == null) return;
    final data = parseNdefRecord(oldRecord.ndefRecord);
    textController.text = data['text'];
  }

  final Record oldRecord;
  final Repository repo;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController textController = TextEditingController();

  Future<int> save() async {
    if (!formKey.currentState.validate()) return null;
    return repo.upsertRecord(Record.fromNdefRecord(
      id: oldRecord?.id,
      ndefRecord: NdefRecord.createText(textController.text),
    ));
  }
}