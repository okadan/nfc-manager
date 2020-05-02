import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/viewmodel/edit_uri.dart';
import 'package:provider/provider.dart';

class EditUriPage extends StatelessWidget {
  static Widget create(Record record) => Provider<EditUriModel>(
    create: (context) => EditUriModel(record),
    child: EditUriPage(),
  );

  @override
  Widget build(BuildContext context) {
    final EditUriModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Uri')),
      body: SafeArea(
        child: Form(
          key: model.formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Container(
                child: TextFormField(
                  controller: model.uriController,
                  decoration: InputDecoration(hintText: 'http://example.com', helperText: ''),
                  keyboardType: TextInputType.url,
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
