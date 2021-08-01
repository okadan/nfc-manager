import 'dart:convert' show ascii, utf8;
import 'dart:typed_data';

import 'package:nfc_manager/nfc_manager.dart';

abstract class Record {
  NdefRecord toNdef();

  static Record fromNdef(NdefRecord record) {
    if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown && record.type.length == 1 && record.type.first == 0x54)
      return WellknownTextRecord.fromNdef(record);
    if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown && record.type.length == 1 && record.type.first == 0x55)
      return WellknownUriRecord.fromNdef(record);
    if (record.typeNameFormat == NdefTypeNameFormat.media)
      return MimeRecord.fromNdef(record);
    if (record.typeNameFormat == NdefTypeNameFormat.absoluteUri)
      return AbsoluteUriRecord.fromNdef(record);
    if (record.typeNameFormat == NdefTypeNameFormat.nfcExternal)
      return ExternalRecord.fromNdef(record);
    return UnsupportedRecord(record);
  }
}

class WellknownTextRecord implements Record {
  WellknownTextRecord({this.identifier, required this.languageCode, required this.text});

  final Uint8List? identifier;

  final String languageCode;

  final String text;

  static WellknownTextRecord fromNdef(NdefRecord record) {
    final languageCodeLength = record.payload.first;
    final languageCodeBytes = record.payload.sublist(1, 1 + languageCodeLength);
    final textBytes = record.payload.sublist(1 + languageCodeLength);
    return WellknownTextRecord(
      identifier: record.identifier,
      languageCode: ascii.decode(languageCodeBytes),
      text: utf8.decode(textBytes),
    );
  }

  @override
  NdefRecord toNdef() {
    return NdefRecord(
      typeNameFormat: NdefTypeNameFormat.nfcWellknown,
      type: Uint8List.fromList([0x54]),
      identifier: identifier ?? Uint8List(0),
      payload: Uint8List.fromList([
        languageCode.length,
        ...ascii.encode(languageCode),
        ...utf8.encode(text),
      ]),
    );
  }
}

class WellknownUriRecord implements Record {
  WellknownUriRecord({this.identifier, required this.uri});

  final Uint8List? identifier;

  final Uri uri;

  static WellknownUriRecord fromNdef(NdefRecord record) {
    final prefix = NdefRecord.URI_PREFIX_LIST[record.payload.first];
    final bodyBytes = record.payload.sublist(1);
    return WellknownUriRecord(
      identifier: record.identifier,
      uri: Uri.parse(prefix + utf8.decode(bodyBytes)),
    );
  }

  @override
  NdefRecord toNdef() {
    var prefixIndex = NdefRecord.URI_PREFIX_LIST
      .indexWhere((e) => uri.toString().startsWith(e), 1);
    if (prefixIndex < 0) prefixIndex = 0;
    final prefix = NdefRecord.URI_PREFIX_LIST[prefixIndex];
    return NdefRecord(
      typeNameFormat: NdefTypeNameFormat.nfcWellknown,
      type: Uint8List.fromList([0x55]),
      identifier: Uint8List(0),
      payload: Uint8List.fromList([
        prefixIndex,
        ...utf8.encode(uri.toString().substring(prefix.length)),
      ]),
    );
  }
}

class MimeRecord implements Record {
  MimeRecord({this.identifier, required this.type, required this.data});

  final Uint8List? identifier;

  final String type;

  final Uint8List data;

  String get dataString => utf8.decode(data);

  static MimeRecord fromNdef(NdefRecord record) {
    return MimeRecord(
      identifier: record.identifier,
      type: ascii.decode(record.type),
      data: record.payload,
    );
  }

  @override
  NdefRecord toNdef() {
    return NdefRecord(
      typeNameFormat: NdefTypeNameFormat.media,
      type: Uint8List.fromList(ascii.encode(type)),
      identifier: identifier ?? Uint8List(0),
      payload: data,
    );
  }
}

class AbsoluteUriRecord implements Record {
  AbsoluteUriRecord({this.identifier, required this.uriType, required this.payload});

  final Uint8List? identifier;

  final Uri uriType;

  final Uint8List payload;

  String get payloadString => utf8.decode(payload);

  static AbsoluteUriRecord fromNdef(NdefRecord record) {
    return AbsoluteUriRecord(
      identifier: record.identifier,
      uriType: Uri.parse(utf8.decode(record.type)),
      payload: record.payload,
    );
  }

  @override
  NdefRecord toNdef() {
    return NdefRecord(
      typeNameFormat: NdefTypeNameFormat.absoluteUri,
      type: Uint8List.fromList(utf8.encode(uriType.toString())),
      identifier: identifier ?? Uint8List(0),
      payload: payload,
    );
  }
}

class ExternalRecord implements Record {
  ExternalRecord({this.identifier, required this.domain, required this.type, required this.data});

  final Uint8List? identifier;

  final String domain;

  final String type;

  final Uint8List data;

  String get domainType => domain + (type.isEmpty ? '' : ':$type');

  String get dataString => utf8.decode(data);

  static ExternalRecord fromNdef(NdefRecord record) {
    final domainType = ascii.decode(record.type);
    final colonIndex = domainType.lastIndexOf(':');
    return ExternalRecord(
      identifier: record.identifier,
      domain: colonIndex < 0 ? domainType : domainType.substring(0, colonIndex),
      type: colonIndex < 0 ? '' : domainType.substring(colonIndex + 1),
      data: record.payload,
    );
  }

  @override
  NdefRecord toNdef() {
    return NdefRecord(
      typeNameFormat: NdefTypeNameFormat.nfcExternal,
      type: Uint8List.fromList(ascii.encode(domainType)),
      identifier: identifier ?? Uint8List(0),
      payload: data,
    );
  }
}

class UnsupportedRecord implements Record {
  UnsupportedRecord(this.record);

  final NdefRecord record;

  static UnsupportedRecord fromNdef(NdefRecord record) {
    return UnsupportedRecord(record);
  }

  @override
  NdefRecord toNdef() => record;
}
