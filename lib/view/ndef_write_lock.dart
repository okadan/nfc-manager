import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/view/widgets/list.dart';
import 'package:flutter_nfc_manager/view/widgets/nfc_session.dart';
import 'package:flutter_nfc_manager/viewmodel/ndef_write_lock.dart';
import 'package:provider/provider.dart';

class NdefWriteLockPage extends StatelessWidget {
  static Widget create() => Provider<NdefWriteLockModel>(
    create: (context) => NdefWriteLockModel(),
    child: NdefWriteLockPage(),
  );

  @override
  Widget build(BuildContext context) {
    final NdefWriteLockModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Ndef - Write Lock')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(2),
          children: [
            ListCellGroup(children: [
              ListCellButton(
                title: Text('Start a scan'),
                onTap: () => startTagSession(context: context, handleTag: model.handleTag),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
