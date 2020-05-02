import 'dart:async';

import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/repository/database.dart';
import 'package:sqflite/sqlite_api.dart';

class RecordRepository {
  RecordRepository._(this._database);
  static RecordRepository _instance;
  static RecordRepository get instance => _instance;
  static Future<void> initialize() async =>
    _instance = RecordRepository._(await getOrCreateDatabase());

  final Database _database;
  final Map<int, StreamController> _controllers = {};
  final Map<int, StreamController> _subscribers = {};

  Stream<Iterable<Record>> getRecordList() {
    final int key = DateTime.now().millisecondsSinceEpoch;
    void fetch() async => _database.query('record')
      .then((value) => value.map((e) => Record.fromJson(e)))
      .then((value) => _controllers[key]?.add(value));
    _subscribers[key] = StreamController(onListen: fetch)
      ..stream.listen((_) => fetch());
    _controllers[key] = StreamController<Iterable<Record>>(onCancel: () {
      _subscribers.remove(key)?.close();
      _controllers.remove(key)?.close();
    });
    return _controllers[key].stream;
  }

  Future<void> insertOrUpdate(Record record) {
    return _database.insert(
      'record',
      record.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((_) => _subscribers.forEach((_, v) => v.add(null)));
  }

  Future<void> delete(Record record) {
    return _database.delete(
      'record',
      where: 'id = ?',
      whereArgs: [record.id],
    ).then((_) => _subscribers.forEach((_, v) => v.add(null)));
  }
}
