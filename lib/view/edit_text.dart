import 'package:app/data/model.dart';
import 'package:app/viewmodel/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTextPage extends StatelessWidget {
  static Widget create(Record record) => ChangeNotifierProvider<EditTextModel>(
    create: (context) => EditTextModel(record, Provider.of(context, listen: false)),
    child: EditTextPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Text')),
      body: SafeArea(
        child: Form(
          key: Provider.of<EditTextModel>(context, listen: false).formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditTextModel>(context, listen: false).textController,
                  decoration: InputDecoration(hintText: 'Text'),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: RaisedButton(
                  child: Text('Save'),
                  onPressed: () => Provider.of<EditTextModel>(context, listen: false).save()
                    .then((v) => v == null ? null : Navigator.pop(context))
                    .catchError((e) => e == null ? null : print('=== $e ===')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
