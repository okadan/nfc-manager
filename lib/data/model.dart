import 'dart:convert' show ascii, utf8;
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:nfc_manager/nfc_manager.dart';

class Record {
  const Record({
    @required this.id,
    @required this.typeNameFormat,
    @required this.type,
    @required this.identifier,
    @required this.payload,
  });

  static const ID = 'id';
  final int id;

  static const TYPE_NAME_FORMAT = 'typeNameFormat';
  final NdefTypeNameFormat typeNameFormat;

  static const TYPE = 'type';
  final Uint8List type;

  static const IDENTIFIER = 'identifier';
  final Uint8List identifier;

  static const PAYLOAD = 'payload';
  final Uint8List payload;

  NdefRecord get ndefRecord => NdefRecord(
    typeNameFormat: typeNameFormat,
    type: type,
    identifier: identifier,
    payload: payload,
  );

  factory Record.fromNdefRecord({
    @required int id,
    @required NdefRecord ndefRecord,
  }) => Record(
    id: id,
    typeNameFormat: ndefRecord.typeNameFormat,
    type: ndefRecord.type,
    identifier: ndefRecord.identifier,
    payload: ndefRecord.payload,
  );

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json[ID],
    typeNameFormat: NdefTypeNameFormat.values.asMap()[json[TYPE_NAME_FORMAT]],
    type: json[TYPE],
    identifier: json[IDENTIFIER] ?? Uint8List.fromList([]),
    payload: json[PAYLOAD],
  );

  Map<String, dynamic> toJson() => {
    ID: id,
    TYPE_NAME_FORMAT: typeNameFormat.index,
    TYPE: type,
    IDENTIFIER: identifier ?? Uint8List.fromList([]),
    PAYLOAD: payload,
  };
}

// FIXME: Consider creating a class instead of a map
Map<String, dynamic> parseNdefRecord(NdefRecord ndefRecord) {
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.empty) {
    return {
      'type': 'empty',
      'title': 'Empty',
      'subtitle': '-',
    };
  }
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
    if (ndefRecord.type.length == 1 && ndefRecord.type.first == 0x54) {
      final languageCodeLength = ndefRecord.payload.first;
      final languageCode = ascii.decode(ndefRecord.payload.sublist(1, 1 + languageCodeLength));
      final text = utf8.decode(ndefRecord.payload.sublist(1 + languageCodeLength));
      return {
        'type': 'text',
        'languageCode': languageCode,
        'text': text,
        'title': 'Text ($languageCode)',
        'subtitle': '$text',
        'editType': 'text',
      };
    }
    if (ndefRecord.type.length == 1 && ndefRecord.type.first == 0x55) {
      final prefix = NdefRecord.URI_PREFIX_LIST[ndefRecord.payload.first];
      final text = utf8.decode(ndefRecord.payload.sublist(1));
      return {
        'type': 'uri',
        'prefix': prefix,
        'text': text,
        'title': 'Uri',
        'subtitle': '$prefix$text',
        'editType': 'uri',
      };
    }
    return {
      'type': 'wellknown',
    };
  }
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.media) {
    return {
      'type': 'media',
      'title': 'Media',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
      'editType': 'mime',
    };
  }
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.absoluteUri) {
    return {
      'type': 'absoluteUri',
      'title': 'Absolute Uri',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.nfcExternal) {
    return {
      'type': 'external',
      'title': 'External',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
      'editType': 'external',
    };
  }
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.unknown) {
    return {
      'type': 'unknown',
      'title': 'Unknown',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  if (ndefRecord.typeNameFormat == NdefTypeNameFormat.unchanged) {
    return {
      'type': 'unchanged',
      'title': 'Unchanged',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  return {};
}
