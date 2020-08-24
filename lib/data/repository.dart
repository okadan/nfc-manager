import 'dart:async';

import 'package:app/data/database.dart';
import 'package:app/data/model.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  Repository._(this._db);

  final Database _db;
  final SubscriptionManager _subscription = SubscriptionManager();

  static Future<Repository> getInstance() async =>
    getDatabase().then((db) => Repository._(db));

  Stream<Iterable<Record>> subscribeRecordList() {
    return _subscription.createStream(() async {
      return _db.query('record')
        .then((v) => v.map((e) => Record.fromJson(e)));
    });
  }

  Future<int> upsertRecord(Record record) async {
    final id = await _db.insert('record', record.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _subscription.publish();
    return id;
  }

  Future<void> deleteRecord(int id) async {
    await _db.delete('record', where: 'id = ?', whereArgs: [id]);
    _subscription.publish();
  }
}

class SubscriptionManager {
  final Map<int, StreamController> _controllers = {};
  final Map<int, StreamController> _subscribers = {};

  Stream<T> createStream<T>(Future<T> Function() fetcher) {
    final key = DateTime.now().microsecondsSinceEpoch;
    final controller = StreamController<T>(onCancel: () {
      _controllers.remove(key)?.close();
      _subscribers.remove(key)?.close();
    });
    void publisher(Future<T> future) => future
      .then(controller.add)
      .catchError(controller.addError);
    _subscribers[key] = StreamController(onListen: () => publisher(fetcher()))
      ..stream.listen((_) => publisher(fetcher()));
    _controllers[key] = controller;
    return controller.stream;
  }

  void publish() =>
    _subscribers.values.forEach((e) => e.add(null));
}
