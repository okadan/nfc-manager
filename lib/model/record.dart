import 'dart:convert' show ascii, utf8;

import 'package:meta/meta.dart';
import 'package:nfc_manager/nfc_manager.dart';

class Record {
  Record({ @required this.id, @required this.ndefRecord });

  final int id;

  final NdefRecord ndefRecord;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json['id'],
    ndefRecord: NdefRecord(
      typeNameFormat: json['typeNameFormat'],
      type: json['type'],
      identifier: json['identifier'],
      payload: json['payload'],
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'typeNameFormat': ndefRecord.typeNameFormat,
    'type': ndefRecord.type,
    'identifier': ndefRecord.identifier,
    'payload': ndefRecord.payload,
  };
}

Map<String, dynamic> parseNdefRecord(NdefRecord ndefRecord) {
  if (ndefRecord.typeNameFormat == 0x00) {
    return {
      'type': 'empty',
      'title': 'Empty',
      'subtitle': '-',
    };
  }
  if (ndefRecord.typeNameFormat == 0x01) {
    if (ndefRecord.type.length == 1 && ndefRecord.type.first == 0x54) {
      final int languageCodeLength = ndefRecord.payload.first;
      final String languageCode = ascii.decode(ndefRecord.payload.sublist(1, 1 + languageCodeLength));
      final String text = utf8.decode(ndefRecord.payload.sublist(1 + languageCodeLength));
      return {
        'type': 'text',
        'languageCode': languageCode,
        'text': text,
        'title': 'Text',
        'subtitle': '($languageCode) $text',
        'editType': 'text',
      };
    }
    if (ndefRecord.type.length == 1 && ndefRecord.type.first == 0x55) {
      final String prefix = NdefRecord.URI_PREFIX_LIST[ndefRecord.payload.first];
      final String text = utf8.decode(ndefRecord.payload.sublist(1));
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
  if (ndefRecord.typeNameFormat == 0x02) {
    return {
      'type': 'media',
      'title': 'Media',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
      'editType': 'mime',
    };
  }
  if (ndefRecord.typeNameFormat == 0x03) {
    return {
      'type': 'absoluteUri',
      'title': 'Absolute Uri',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  if (ndefRecord.typeNameFormat == 0x04) {
    return {
      'type': 'external',
      'title': 'External',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
      'editType': 'external',
    };
  }
  if (ndefRecord.typeNameFormat == 0x05) {
    return {
      'type': 'unknown',
      'title': 'Unknown',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  if (ndefRecord.typeNameFormat == 0x06) {
    return {
      'type': 'unchanged',
      'title': 'Unchanged',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  if (ndefRecord.typeNameFormat == 0x07) {
    return {
      'type': 'reserved',
      'title': 'Reserved',
      'subtitle': '(${utf8.decode(ndefRecord.type)}) ${utf8.decode(ndefRecord.payload)}',
    };
  }
  return {};
}

String typeNameFormatToString(int typeNameFormat) {
  switch (typeNameFormat) {
    case 0x00:
      return 'Empty';
    case 0x01:
      return 'NFC Well Known';
    case 0x02:
      return 'Media';
    case 0x03:
      return 'Absolute URI';
    case 0x04:
      return 'NFC External';
    case 0x05:
      return 'Unknown';
    case 0x06:
      return 'Unchanged';
    case 0x07:
      return 'Reserved';
    default:
      return 'NA';
  }
}
