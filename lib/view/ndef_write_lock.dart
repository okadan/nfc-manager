import 'package:app/view/common/form_row.dart';
import 'package:app/view/common/nfc_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

class NdefWriteLockModel with ChangeNotifier {
  Future<String?> handleTag(NfcTag tag) async {
    final tech = Ndef.from(tag);

    if (tech == null)
      throw('Tag is not ndef.');

    // Check android-specific property.
    if (tech.additionalData['canMakeReadOnly'] == false)
      throw('This operation is not allowed on this tag.');

    try {
      await tech.writeLock();
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }

    return '[Ndef - Write Lock] is completed.';
  }
}

class NdefWriteLockPage extends StatelessWidget {
  static Widget withDependency() => ChangeNotifierProvider<NdefWriteLockModel>(
    create: (context) => NdefWriteLockModel(),
    child: NdefWriteLockPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ndef - Write Lock'),
      ),
      body: ListView(
        padding: EdgeInsets.all(2),
        children: [
          FormSection(children: [
            FormRow(
              title: Text('Start Session', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              onTap: () async {
                final result = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
                  title: Text('Warning'),
                  content: Text(
                    'This is a permanent action that you cannot undo. '
                    'After locking the tag, you can no longer write data to it.',
                  ),
                  actions: [
                    TextButton(child: Text('CANCEL'), onPressed: () => Navigator.pop(context)),
                    TextButton(child: Text('START'), onPressed: () => Navigator.pop(context, true)),
                  ],
                ));
                if (result == true)
                  startSession(
                    context: context,
                    handleTag: Provider.of<NdefWriteLockModel>(context, listen: false).handleTag,
                  );
              },
            ),
          ]),
        ],
      ),
    );
  }
}
