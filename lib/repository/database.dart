import 'package:sqflite/sqflite.dart';

const String _kPath = 'nfc_manager.db';

Future<Database> getOrCreateDatabase() {
  return openDatabase(
    _kPath,
    version: 1,
    singleInstance: true,
    onCreate: (db, version) async {
      Batch batch = db.batch();
      await _v1(batch, version);
      await batch.commit();
    },
  );
}

Future<void> _v1(Batch batch, int version) async {
  batch.execute('DROP TABLE IF EXISTS record');
  batch.execute(
    'CREATE TABLE record ('
      'id INTEGER PRIMARY KEY,'
      'typeNameFormat INTEGER NOT NULL,'
      'type BLOB NOT NULL,'
      'identifier BLOB NOT NULL,'
      'payload BLOB NOT NULL'
    ')'
  );
}
