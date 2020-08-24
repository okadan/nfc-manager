import 'package:app/data/model.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  return openDatabase(
    'nfc_manager.db',
    version: 1,
    singleInstance: true,
    onCreate: (db, version) async {
      final batch = db.batch();
      await _$1(batch);
      await batch.commit();
    },
  );
}

Future<void> _$1(Batch batch) async {
  batch.execute('''
    CREATE TABLE record (
      ${Record.ID} INTEGER PRIMARY KEY,
      ${Record.TYPE_NAME_FORMAT} INTEGER NOT NULL,
      ${Record.TYPE} BLOB NOT NULL,
      ${Record.IDENTIFIER} BLOB NOT NULL,
      ${Record.PAYLOAD} BLOB NOT NULL
    )
  ''');
}
