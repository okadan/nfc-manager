import 'package:app/data/model.dart';
import 'package:app/viewmodel/edit_mime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMimePage extends StatelessWidget {
  static Widget create(Record record) => ChangeNotifierProvider<EditMimeModel>(
    create: (context) => EditMimeModel(record, Provider.of(context, listen: false)),
    child: EditMimePage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Mime')),
      body: SafeArea(
        child: Form(
          key: Provider.of<EditMimeModel>(context, listen: false).formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditMimeModel>(context, listen: false).typeController,
                  decoration: InputDecoration(hintText: 'text/plain'),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditMimeModel>(context, listen: false).dataController,
                  decoration: InputDecoration(hintText: 'Hello'),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () => Provider.of<EditMimeModel>(context, listen: false).save()
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
