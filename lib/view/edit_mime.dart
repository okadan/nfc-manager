import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/viewmodel/edit_mime.dart';
import 'package:provider/provider.dart';

class EditMimePage extends StatelessWidget {
  static Widget create(Record record) => Provider<EditMimeModel>(
    create: (context) => EditMimeModel(record),
    child: EditMimePage(),
  );

  @override
  Widget build(BuildContext context) {
    final EditMimeModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Mime')),
      body: SafeArea(
        child: Form(
          key: model.formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Container(
                child: TextFormField(
                  controller: model.typeController,
                  decoration: InputDecoration(hintText: 'text/plain', helperText: ''),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                child: TextFormField(
                  controller: model.dataController,
                  decoration: InputDecoration(hintText: 'Hello', helperText: ''),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () => model.save()
                    .then((_) => Navigator.pop(context))
                    .catchError((_) {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
