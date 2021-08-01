import 'package:app/view/common/form_row.dart';
import 'package:app/view/common/nfc_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';

class NdefFormatModel with ChangeNotifier {
  Future<String?> handleTag(NfcTag tag) async {
    final tech = NdefFormatable.from(tag);

    if (tech == null)
      throw('Tag is not ndef formatable.');

    try {
      await tech.format(NdefMessage([]));
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }

    return '[Ndef - Format] is completed.';
  }
}

class NdefFormatPage extends StatelessWidget {
  static Widget withDependency() => ChangeNotifierProvider<NdefFormatModel>(
    create: (context) => NdefFormatModel(),
    child: NdefFormatPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ndef - Format'),
      ),
      body: ListView(
        padding: EdgeInsets.all(2),
        children: [
          FormSection(children: [
            FormRow(
              title: Text('Start Session', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              onTap: () => startSession(
                context: context,
                handleTag: Provider.of<NdefFormatModel>(context, listen: false).handleTag,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
