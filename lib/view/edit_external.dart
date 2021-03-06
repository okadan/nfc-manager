import 'dart:convert';
import 'dart:typed_data';

import 'package:app/model/record.dart';
import 'package:app/model/write_record.dart';
import 'package:app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditExternalModel with ChangeNotifier {
  EditExternalModel(this._repo, this.old) {
    if (old == null) return;
    final record = ExternalRecord.fromNdef(old!.record);
    domainController.text = record.domain;
    typeController.text = record.type;
    dataController.text = record.dataString;
  }

  final Repository _repo;
  final WriteRecord? old;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<Object> save() async {
    if (!formKey.currentState!.validate())
      throw('Form is invalid.');

    final record = ExternalRecord(
      domain: domainController.text,
      type: typeController.text,
      data: Uint8List.fromList(utf8.encode(dataController.text)),
    );

    return _repo.createOrUpdateWriteRecord(WriteRecord(
      id: old?.id,
      record: record.toNdef(),
    ));
  }
}

class EditExternalPage extends StatelessWidget {
  EditExternalPage._();

  static Widget create([WriteRecord? record]) => ChangeNotifierProvider<EditExternalModel>(
    create: (context) => EditExternalModel(Provider.of(context, listen: false), record),
    child: EditExternalPage._(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit External'),
      ),
      body: Form(
        key: Provider.of<EditExternalModel>(context, listen: false).formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Container(
              child: TextFormField(
                controller: Provider.of<EditExternalModel>(context, listen: false).domainController,
                decoration: InputDecoration(labelText: 'Domain',  helperText: ''),
                keyboardType: TextInputType.text,
                validator: (value) => value?.isNotEmpty != true ? 'Required' : null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: Provider.of<EditExternalModel>(context, listen: false).typeController,
                decoration: InputDecoration(labelText: 'Type', helperText: ''),
                keyboardType: TextInputType.text,
                validator: (value) => value?.isNotEmpty != true ? 'Required' : null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: Provider.of<EditExternalModel>(context, listen: false).dataController,
                decoration: InputDecoration(labelText: 'Data', helperText: ''),
                keyboardType: TextInputType.text,
                validator: (value) => value?.isNotEmpty != true ? 'Required' : null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: ElevatedButton(
                child: Text('Save'),
                onPressed: () => Provider.of<EditExternalModel>(context, listen: false).save()
                  .then((_) => Navigator.pop(context))
                  .catchError((e) => print('=== $e ===')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
