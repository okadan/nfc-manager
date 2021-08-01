import 'dart:convert';
import 'dart:typed_data';

import 'package:app/model/record.dart';
import 'package:app/model/write_record.dart';
import 'package:app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMimeModel with ChangeNotifier {
  EditMimeModel(this._repo, this.old) {
    if (old == null) return;
    final record = MimeRecord.fromNdef(old!.record);
    typeController.text = record.type;
    dataController.text = record.dataString;
  }

  final Repository _repo;
  final WriteRecord? old;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<Object> save() async {
    if (!formKey.currentState!.validate())
      throw('Form is invalid.');

    final record = MimeRecord(
      type: typeController.text,
      data: Uint8List.fromList(utf8.encode(dataController.text)),
    );

    return _repo.createOrUpdateWriteRecord(WriteRecord(
      id: old?.id,
      record: record.toNdef(),
    ));
  }
}

class EditMimePage extends StatelessWidget {
  static Widget withDependency([WriteRecord? record]) => ChangeNotifierProvider<EditMimeModel>(
    create: (context) => EditMimeModel(Provider.of(context, listen: false), record),
    child: EditMimePage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mime'),
      ),
      body: Form(
        key: Provider.of<EditMimeModel>(context, listen: false).formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: Provider.of<EditMimeModel>(context, listen: false).typeController,
              decoration: InputDecoration(labelText: 'Type', hintText: 'text/plain', helperText: ''),
              keyboardType: TextInputType.text,
              validator: (value) => value?.isNotEmpty != true ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: Provider.of<EditMimeModel>(context, listen: false).dataController,
              decoration: InputDecoration(labelText: 'Data', helperText: ''),
              keyboardType: TextInputType.text,
              validator: (value) => value?.isNotEmpty != true ? 'Required' : null,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () => Provider.of<EditMimeModel>(context, listen: false).save()
                .then((_) => Navigator.pop(context))
                .catchError((e) => print('=== $e ===')),
            ),
          ],
        ),
      ),
    );
  }
}
