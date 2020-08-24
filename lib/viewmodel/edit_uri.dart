import 'package:app/data/model.dart';
import 'package:app/data/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditUriModel with ChangeNotifier {
  EditUriModel(this.oldRecord, this.repo) {
    if (oldRecord == null) return;
    final data = parseNdefRecord(oldRecord.ndefRecord);
    uriController.text = '${data['prefix']}${data['text']}';
  }

  final Record oldRecord;
  final Repository repo;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController uriController = TextEditingController();

  Future<int> save() async {
    if (!formKey.currentState.validate()) return null;
    return repo.upsertRecord(Record.fromNdefRecord(
      id: oldRecord?.id,
      ndefRecord: NdefRecord.createUri(Uri.parse(uriController.text)),
    ));
  }
}
