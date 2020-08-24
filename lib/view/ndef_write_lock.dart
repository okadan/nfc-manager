import 'package:app/view/common/list.dart';
import 'package:app/view/common/nfc_session.dart';
import 'package:app/viewmodel/ndef_write_lock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NdefWriteLockPage extends StatelessWidget {
  static Widget create() => ChangeNotifierProvider<NdefWriteLockModel>(
    create: (context) => NdefWriteLockModel(),
    child: NdefWriteLockPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ndef - Write Lock'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(2),
          children: [
            ListCellGroup(children: [
              ListCellButton(
                title: Text('Start a scan'),
                onTap: () => startSession(
                  context: context,
                  handleTag: Provider.of<NdefWriteLockModel>(context, listen: false).handleTag,
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
