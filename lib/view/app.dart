import 'package:app/data/repository.dart';
import 'package:app/view/about.dart';
import 'package:app/view/common/list.dart';
import 'package:app/view/edit_external.dart';
import 'package:app/view/edit_mime.dart';
import 'package:app/view/edit_text.dart';
import 'package:app/view/edit_uri.dart';
import 'package:app/view/ndef_record.dart';
import 'package:app/view/ndef_write.dart';
import 'package:app/view/ndef_write_lock.dart';
import 'package:app/view/tag_read.dart';
import 'package:app/viewmodel/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  static Widget create() => MultiProvider(
    providers: [
      FutureProvider<Repository>(
        lazy: false,
        create: (context) => Repository.getInstance(),
      ),
      ChangeNotifierProvider<AppModel>(
        create: (context) => AppModel(),
      ),
    ],
    child: App(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Home.create(),
      theme: _themeData(context),
      darkTheme: _themeDataDark(context),
      onGenerateRoute: _generateRoute,
    );
  }
}

class _Home extends StatelessWidget {
  static Widget create() => ChangeNotifierProvider<HomeModel>(
    create: (context) => HomeModel(),
    child: _Home(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NfcManager'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(2),
          children: [
            ListCellGroup(children: [
              ListCell(
                title: Text('Tag - Read'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/tag_read'),
              ),
              ListCell(
                title: Text('Ndef - Write'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/ndef_write'),
              ),
              ListCell(
                title: Text('Ndef - Write Lock'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/ndef_write_lock'),
              ),
            ]),
            ListCellGroup(children: [
              ListCell(
                title: Text('About'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

ThemeData _themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(elevation: 2.0),
    cardTheme: CardTheme(elevation: 0.5),
    splashColor: Colors.transparent,
    visualDensity: VisualDensity.comfortable,
  );
}

ThemeData _themeDataDark(BuildContext context) {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(elevation: 2.0),
    cardTheme: CardTheme(elevation: 0.5),
    splashColor: Colors.transparent,
    visualDensity: VisualDensity.comfortable,
  );
}

Route<dynamic> _generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/tag_read':
      return MaterialPageRoute(
        builder: (context) => TagReadPage.create(),
      );
    case '/ndef_write':
      return MaterialPageRoute(
        builder: (context) => NdefWritePage.create(),
      );
    case '/ndef_write_lock':
      return MaterialPageRoute(
        builder: (context) => NdefWriteLockPage.create(),
      );
    case '/edit_text':
      return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditTextPage.create(settings.arguments),
      );
    case '/edit_uri':
      return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditUriPage.create(settings.arguments),
      );
    case '/edit_mime':
      return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditMimePage.create(settings.arguments),
      );
    case '/edit_external':
      return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditExternalPage.create(settings.arguments),
      );
    case '/ndef_record':
      return MaterialPageRoute(
        builder: (context) => NdefRecordPage.create(settings.arguments),
      );
    case '/about':
      return MaterialPageRoute(
        builder: (context) => AboutPage.create(),
      );
    default:
      return null;
  }
}
