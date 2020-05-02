import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/viewmodel/edit_external.dart';
import 'package:provider/provider.dart';

class EditExternalPage extends StatelessWidget {
  static Widget create(Record record) => Provider<EditExternalModel>(
    create: (context) => EditExternalModel(record),
    child: EditExternalPage(),
  );

  @override
  Widget build(BuildContext context) {
    final EditExternalModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Edit External')),
      body: SafeArea(
        child: Form(
          key: model.formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Container(
                child: TextFormField(
                  controller: model.domainController,
                  decoration: InputDecoration(hintText: 'Domain', helperText: ''),
                  keyboardType: TextInputType.url,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                child: TextFormField(
                  controller: model.typeController,
                  decoration: InputDecoration(hintText: 'Type', helperText: ''),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                child: TextFormField(
                  controller: model.dataController,
                  decoration: InputDecoration(hintText: 'Data', helperText: ''),
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
