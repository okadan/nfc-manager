import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/util/extensions.dart';
import 'package:flutter_nfc_manager/view/widgets/list.dart';
import 'package:flutter_nfc_manager/viewmodel/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

class NdefRecordPage extends StatelessWidget {
  static Widget create(NdefRecord ndefRecord) => Provider<NdefRecordModel>(
    create: (context) => NdefRecordModel(ndefRecord),
    child: NdefRecordPage(),
  );

  @override
  Widget build(BuildContext context) {
    final NdefRecordModel model = Provider.of(context);
    final Map<String, dynamic> data = parseNdefRecord(model.ndefRecord);
    return Scaffold(
      appBar: AppBar(title: Text('${data['title']}')),
      body: ListView(
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
              subtitle: Text(typeNameFormatToString(model.ndefRecord.typeNameFormat)),
            ),
            ListCell(
              title: Text('Type'),
              subtitle: Text('${model.ndefRecord.type.toHexString()}'),
            ),
            ListCell(
              title: Text('Identifier'),
              subtitle: Text('${model.ndefRecord.identifier.toHexString()}'),
            ),
            ListCell(
              title: Text('Payload'),
              subtitle: Text('${model.ndefRecord.payload.toHexString()}'),
            ),
            ListCell(
              title: Text('Total Size'),
              subtitle: Text('${model.ndefRecord.byteLength} bytes'),
            ),
          ]),
        ],
      ),
    );
  }
}
