import 'package:app/data/model.dart';
import 'package:app/viewmodel/edit_external.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditExternalPage extends StatelessWidget {
  static Widget create(Record record) => ChangeNotifierProvider<EditExternalModel>(
    create: (context) => EditExternalModel(record, Provider.of(context, listen: false)),
    child: EditExternalPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit External')),
      body: SafeArea(
        child: Form(
          key: Provider.of<EditExternalModel>(context, listen: false).formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditExternalModel>(context, listen: false).domainController,
                  decoration: InputDecoration(hintText: 'Domain'),
                  keyboardType: TextInputType.url,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditExternalModel>(context, listen: false).typeController,
                  decoration: InputDecoration(hintText: 'Type'),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 72),
                child: TextFormField(
                  controller: Provider.of<EditExternalModel>(context, listen: false).dataController,
                  decoration: InputDecoration(hintText: 'Data'),
                  keyboardType: TextInputType.text,
                  validator: (v) => v.isEmpty ? 'required' : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () => Provider.of<EditExternalModel>(context, listen: false).save()
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
