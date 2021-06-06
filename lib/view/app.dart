import 'dart:io';

import 'package:app/repository/repository.dart';
import 'package:app/view/about.dart';
import 'package:app/view/common/form_row.dart';
import 'package:app/view/ndef_format.dart';
import 'package:app/view/ndef_write.dart';
import 'package:app/view/ndef_write_lock.dart';
import 'package:app/view/tag_read.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App._();

  static Future<Widget> create() async {
    final repository = await Repository.createInstance();
    return MultiProvider(
      providers: [
        Provider<Repository>.value(
          value: repository,
        ),
      ],
      child: App._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Home.create(),
      theme: _createTheme(context),
    );
  }
}

class _Home extends StatelessWidget {
  _Home._();

  static Widget create() => _Home._();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Manager'),
      ),
      body: ListView(
        padding: EdgeInsets.all(2),
        children: [
          FormSection(
            children: [
              FormRow(
                title: Text('Tag - Read'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TagReadPage.create(),
                )),
              ),
              FormRow(
                title: Text('Ndef - Write'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NdefWritePage.create(),
                )),
              ),
              FormRow(
                title: Text('Ndef - Write Lock'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NdefWriteLockPage.create(),
                )),
              ),
              if (Platform.isAndroid)
                FormRow(
                  title: Text('Ndef - Format'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => NdefFormatPage.create(),
                  )),
                ),
            ],
          ),
          FormSection(
            children: [
              FormRow(
                title: Text('About'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AboutPage.create(),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

ThemeData _createTheme(BuildContext context) {
  return ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      errorStyle: TextStyle(height: 0.7),
      helperStyle: TextStyle(height: 0.7),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
    )),
  );
}
