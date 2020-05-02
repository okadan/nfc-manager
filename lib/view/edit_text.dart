import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/viewmodel/edit_text.dart';
import 'package:provider/provider.dart';

class EditTextPage extends StatelessWidget {
  static Widget create(Record record) => Provider<EditTextModel>(
    create: (context) => EditTextModel(record),
    child: EditTextPage(),
  );

  @override
  Widget build(BuildContext context) {
    final EditTextModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Text')),
      body: SafeArea(
        child: Form(
          key: model.formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Container(
                child: TextFormField(
                  controller: model.textController,
                  decoration: InputDecoration(hintText: 'Text', helperText: ''),
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
