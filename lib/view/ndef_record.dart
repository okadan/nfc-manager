import 'package:app/extension/extension.dart';
import 'package:app/model/record.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NdefRecordPage extends StatelessWidget {
  const NdefRecordPage(this.index, this.record);

  final int index;

  final NdefRecord record;

  Widget _buildColumn(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Text(subtitle, style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = NdefRecordInfo.fromNdef(record);
    return Scaffold(
      appBar: AppBar(
        title: Text('Record #$index'),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Container(
            child: _buildColumn(context, info.title, info.subtitle),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: _buildColumn(context, 'Size', '${record.byteLength} bytes'),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: _buildColumn(context, 'Type Name Format', '${record.typeNameFormat.index.toHexString()}'),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: _buildColumn(context, 'Type', '${record.type.toHexString()}'),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: _buildColumn(context, 'Identifier', '${record.identifier.toHexString()}'),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: _buildColumn(context, 'Payload', '${record.payload.toHexString()}'),
          ),
        ],
      ),
    );
  }
}

class NdefRecordInfo {
  const NdefRecordInfo({required this.record, required this.title, required this.subtitle});

  final Record record;

  final String title;

  final String subtitle;

  static NdefRecordInfo fromNdef(NdefRecord record) {
    final _record = Record.fromNdef(record);
    if (_record is EmptyRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Empty',
        subtitle: '-',
      );
    if (_record is WellknownTextRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Text',
        subtitle: '(${_record.languageCode}) ${_record.text}',
      );
    if (_record is WellknownUriRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Uri',
        subtitle: '${_record.uri}',
      );
    if (_record is MimeRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Mime',
        subtitle: '(${_record.type}) ${_record.dataString}',
      );
    if (_record is AbsoluteUriRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Absolute Uri',
        subtitle: '(${_record.uriType}) ${_record.payloadString}',
      );
    if (_record is ExternalRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'External',
        subtitle: '(${_record.domainType}) ${_record.dataString}',
      );
    if (_record is UnsupportedRecord)
      return NdefRecordInfo(
        record: _record,
        title: _typeNameFormatToString(_record.record.typeNameFormat),
        subtitle: '(${_record.record.type.toHexString()}) ${_record.record.payload.toHexString()}',
      );
    throw UnimplementedError();
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
