import 'package:app/data/model.dart';
import 'package:app/viewmodel/edit_uri.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUriPage extends StatelessWidget {
  static Widget create(Record record) => ChangeNotifierProvider<EditUriModel>(
    create: (context) => EditUriModel(record, Provider.of(context, listen: false)),
    child: EditUriPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Uri')),
      body: SafeArea(
        child: Form(
          key: Provider.of<EditUriModel>(context, listen: false).formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditUriModel>(context, listen: false).uriController,
                  decoration: InputDecoration(hintText: 'http://example.com'),
                  keyboardType: TextInputType.url,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: RaisedButton(
                  child: Text('Save'),
                  onPressed: () => Provider.of<EditUriModel>(context, listen: false).save()
                    .then((v) => v == null ? null : Navigator.pop(context))
                    .catchError((e) => print('=== $e ===')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
