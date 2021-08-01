import 'package:sqflite/sqflite.dart';

Future<Database> getOrCreateDatabase() {
  return openDatabase(
    'nfc_manager.db',
    version: 1,
    singleInstance: true,
    onUpgrade: (db, oldVersion, newVersion) async {
      bool _shouldMigrate(int version) =>
        oldVersion < version && version <= newVersion;
      final batch = db.batch();
      if (_shouldMigrate(1)) await _migrate1(batch);
      // more migration here. ex:
      // if (_shouldMigrate(2)) await _migrate2(batch);
      await batch.commit();
    },
  );
}

Future<void> _migrate1(Batch batch) async {
  batch.execute('''
    CREATE TABLE record (
      id INTEGER PRIMARY KEY,
      typeNameFormat INTEGER NOT NULL,
      type BLOB NOT NULL,
      identifier BLOB NOT NULL,
      payload BLOB NOT NULL
    )
  ''');
}
