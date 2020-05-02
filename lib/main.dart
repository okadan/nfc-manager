import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_manager/repository/record.dart';
import 'package:flutter_nfc_manager/view/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RecordRepository.initialize();
  runApp(App.create());
}
