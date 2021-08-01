import 'package:app/model/record.dart';
import 'package:app/model/write_record.dart';
import 'package:app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUriModel with ChangeNotifier {
  EditUriModel(this._repo, this.old) {
    if (old == null) return;
    final record = WellknownUriRecord.fromNdef(old!.record);
    uriController.text = record.uri.toString();
  }

  final Repository _repo;
  final WriteRecord? old;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController uriController = TextEditingController();

  Future<Object> save() async {
    if (!formKey.currentState!.validate())
      throw('Form is invalid.');

    final record = WellknownUriRecord(
      uri: Uri.parse(uriController.text),
    );

    return _repo.createOrUpdateWriteRecord(WriteRecord(
      id: old?.id,
      record: record.toNdef(),
    ));
  }
}

class EditUriPage extends StatelessWidget {
  static Widget withDependency([WriteRecord? record]) => ChangeNotifierProvider<EditUriModel>(
    create: (context) => EditUriModel(Provider.of(context, listen: false), record),
    child: EditUriPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Uri'),
      ),
      body: Form(
        key: Provider.of<EditUriModel>(context, listen: false).formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: Provider.of<EditUriModel>(context, listen: false).uriController,
              decoration: InputDecoration(labelText: 'Uri', hintText: 'http://example.com', helperText: ''),
              keyboardType: TextInputType.url,
              validator: (value) => value?.isNotEmpty != true ? 'Required' : Uri.tryParse(value!) == null ? 'Invalid' : null,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () => Provider.of<EditUriModel>(context, listen: false).save()
                .then((_) => Navigator.pop(context))
                .catchError((e) => print('=== $e ===')),
            ),
          ],
        ),
      ),
    );
  }
}
