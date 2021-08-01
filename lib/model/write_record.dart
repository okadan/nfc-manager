import 'package:nfc_manager/nfc_manager.dart';

class WriteRecord {
  WriteRecord({required this.id, required this.record});

  static const ID = 'id';
  final int? id;

  static const TYPE_NAME_FORMAT = 'typeNameFormat';
  static const TYPE = 'type';
  static const IDENTIFIER = 'identifier';
  static const PAYLOAD = 'payload';
  final NdefRecord record;

  factory WriteRecord.fromJson(Map<String, dynamic> json) {
    return WriteRecord(
      id: json[ID],
      record: NdefRecord(
        typeNameFormat: NdefTypeNameFormat.values[json[TYPE_NAME_FORMAT]],
        type: json[TYPE],
        identifier: json[IDENTIFIER],
        payload: json[PAYLOAD],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      TYPE_NAME_FORMAT: record.typeNameFormat.index,
      TYPE: record.type,
      IDENTIFIER: record.identifier,
      PAYLOAD: record.payload,
    };
  }
}
