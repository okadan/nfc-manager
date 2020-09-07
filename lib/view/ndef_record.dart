import 'package:app/data/model.dart';
import 'package:app/util/util.dart';
import 'package:app/view/common/list.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NdefRecordPage extends StatelessWidget {
  static Widget create(NdefRecord record) => NdefRecordPage(record);

  NdefRecordPage(this.record);

  final NdefRecord record;

  @override
  Widget build(BuildContext context) {
    final data = parseNdefRecord(record);
    return Scaffold(
      appBar: AppBar(
        title: Text('${data['title']}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(2),
          children: [
            ListCellGroup(children: [
              ListCell(
                title: Text('${data['subtitle']}'),
              ),
            ]),
            ListCellGroup(children: [
              ListCell(
                title: Text('Type Name Format'),
                subtitle: Text(_typeNameFormatToString(record.typeNameFormat)),
              ),
              ListCell(
                title: Text('Type'),
                subtitle: Text(hexFromBytes(record.type)),
              ),
              ListCell(
                title: Text('Identifier'),
                subtitle: Text(hexFromBytes(record.identifier)),
              ),
              ListCell(
                title: Text('Payload'),
                subtitle: Text(hexFromBytes(record.payload)),
              ),
              ListCell(
                title: Text('Total Size'),
                subtitle: Text('${record.byteLength} bytes'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

String _typeNameFormatToString(NdefTypeNameFormat format) {
  switch (format) {
    case NdefTypeNameFormat.empty:
      return 'Empty';
    case NdefTypeNameFormat.nfcWellknown:
      return 'NFC Wellknown';
    case NdefTypeNameFormat.media:
      return 'Media';
    case NdefTypeNameFormat.absoluteUri:
      return 'Absolute Uri';
    case NdefTypeNameFormat.nfcExternal:
      return 'NFC External';
    case NdefTypeNameFormat.unknown:
      return 'Unknown';
    case NdefTypeNameFormat.unchanged:
      return 'Unchanged';
    default:
      return 'NA';
  }
}
