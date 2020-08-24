import 'package:app/data/model.dart';
import 'package:app/view/common/list.dart';
import 'package:app/view/common/nfc_session.dart';
import 'package:app/viewmodel/ndef_write.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NdefWritePage extends StatelessWidget {
  static Widget create() => ChangeNotifierProvider<NdefWriteModel>(
    create: (context) => NdefWriteModel(Provider.of(context, listen: false)),
    child: NdefWritePage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ndef - Write'),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<Record>>(
          stream: Provider.of<NdefWriteModel>(context, listen: false).subscribe(),
          builder: (context, ss) => ListView(
            padding: EdgeInsets.all(2),
            children: [
              ListCellGroup(children: [
                ListCell(
                  title: Text('Add a record'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('Select a record type'),
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
                  onTap: !ss.hasData || ss.data.isEmpty ? null : () => startSession(
                    context: context,
                    handleTag: (tag) =>
                      Provider.of<NdefWriteModel>(context, listen: false).handleTag(tag, ss.data),
                  ),
                ),
              ]),

              if (ss.hasData && ss.data.isNotEmpty) ...[
                ListHeader(label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RECORDS'),
                    Text('Total ${ss.data.map((e) => e.ndefRecord.byteLength).reduce((a, b) => a + b)} bytes'),
                  ],
                )),
                ListCellGroup(children: List.generate(ss.data.length, (i) {
                  final record = ss.data.elementAt(i);
                  final data = parseNdefRecord(record.ndefRecord);
                  return ListCell(
                    title: Text('#$i ${data['title']}'),
                    subtitle: Text('${data['subtitle']}'),
                    trailing: Icon(Icons.more_vert),
                    onTap: () async {
                      switch (await showModalBottomSheet(context: context, builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListHeader(label: Text('#$i ${data['title']} ${data['subtitle']}')),
                            ListCell(title: Text('View Details'), onTap: () => Navigator.pop(context, 'viewDetails')),
                            if (data['editType'] is String) ListCell(title: Text('Edit'), onTap: () => Navigator.pop(context, 'edit')),
                            ListCell(title: Text('Delete'), onTap: () => Navigator.pop(context, 'delete')),
                          ],
                        ),
                      ))) {
                        case 'viewDetails':
                          Navigator.pushNamed(context, '/ndef_record', arguments: record.ndefRecord);
                          break;
                        case 'edit':
                          Navigator.pushNamed(context, '/edit_${data['editType']}', arguments: record);
                          break;
                        case 'delete':
                          if ((await showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text('Delete?'),
                            content: Text('#$i ${data['title']} : ${data['subtitle']}'),
                            actions: [
                              FlatButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context, false)),
                              FlatButton(child: Text('Delete'), onPressed: () => Navigator.pop(context, true)),
                            ],
                          ))) == true) Provider.of<NdefWriteModel>(context, listen: false).delete(record)
                            .catchError((e) => print('=== $e ==='));
                          break;
                      }
                    },
                  );
                })),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
