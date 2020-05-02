import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/view/widgets/list.dart';
import 'package:flutter_nfc_manager/view/widgets/nfc_session.dart';
import 'package:flutter_nfc_manager/viewmodel/ndef_write.dart';
import 'package:provider/provider.dart';

class NdefWritePage extends StatelessWidget {
  static Widget create() => Provider<NdefWriteModel>(
    create: (context) => NdefWriteModel(),
    child: NdefWritePage(),
  );

  @override
  Widget build(BuildContext context) {
    final NdefWriteModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Ndef - Write')),
      body: SafeArea(
        child: StreamBuilder<Iterable<Record>>(
          stream: model.subscribe(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('${snapshot.error}'));
            if (!snapshot.hasData)
              return Center(child: Text('Loading...'));
            return ListView(
              padding: EdgeInsets.all(2),
              children: [
                ListCellGroup(children: [
                  ListCell(
                    title: Text('Add a record'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text('Record type'),
                        children: [
                          SimpleDialogOption(
                            child: Text('Text'),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/edit_text'),
                          ),
                          SimpleDialogOption(
                            child: Text('Uri'),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/edit_uri'),
                          ),
                          SimpleDialogOption(
                            child: Text('Mime'),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/edit_mime'),
                          ),
                          SimpleDialogOption(
                            child: Text('External'),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/edit_external'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListCellButton(
                    title: Text('Start a scan'),
                    onTap: snapshot.data.isEmpty ? null : () => startTagSession(
                      context: context, handleTag: (tag) => model.handleTag(tag, snapshot.data),
                    ),
                  ),
                ]),
                if (snapshot.data.isNotEmpty) ...[
                  // FIXME: consider replacing this Container with ListCellHeader
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Total: ${snapshot.data.map((e) => e.ndefRecord.byteLength).reduce((a, b) => a + b)} bytes'),
                  ),
                  ListCellGroup(children: List.generate(snapshot.data.length, (i) {
                    final Record record = snapshot.data.elementAt(i);
                    final Map<String, dynamic> data = parseNdefRecord(record.ndefRecord);
                    return ListCell(
                      title: Text('#$i ${data['title']}'),
                      subtitle: Text('${data['subtitle']}'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // FIXME: consider replacing this Container with ListCellHeader
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text('#$i ${data['title']} ${data['subtitle']}', style: Theme.of(context).textTheme.subtitle2),
                              ),
                              ListCell(
                                title: Text('View Details'),
                                onTap: () => Navigator.pushReplacementNamed(context, '/ndef_record', arguments: record.ndefRecord),
                              ),
                              if (data['editType'] is String)
                                ListCell(
                                  title: Text('Edit'),
                                  onTap: () => Navigator.pushReplacementNamed(context, '/edit_${data['editType']}', arguments: record),
                                ),
                              ListCell(
                                title: Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete?'),
                                      content: Text('#$i ${data['title']} : ${data['subtitle']}'),
                                      actions: [
                                        FlatButton(
                                          child: Text('Cancel'),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        FlatButton(
                                          child: Text('Delete'),
                                          onPressed: () => model.delete(record)
                                            .then((_) => Navigator.pop(context))
                                            .catchError((e) => print('=== $e ===')),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
