import 'dart:io';
import 'dart:typed_data';

import 'package:app/data/model.dart';
import 'package:app/util/util.dart';
import 'package:app/view/common/list.dart';
import 'package:app/view/common/nfc_session.dart';
import 'package:app/viewmodel/tag_read.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';

class TagReadPage extends StatelessWidget {
  static Widget create() => ChangeNotifierProvider<TagReadModel>(
    create: (context) => TagReadModel(),
    child: TagReadPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag - Read'),
      ),
      body: SafeArea(
        child: Consumer<TagReadModel>(
          builder: (context, model, child) => ListView(
            padding: EdgeInsets.all(2),
            children: [
              ListCellGroup(children: [
                ListCellButton(
                  title: Text('Start a scan'),
                  onTap: () => startSession(
                    context: context,
                    handleTag: Provider.of<TagReadModel>(context, listen: false).handleTag,
                  ),
                ),
              ]),

              if (model.tag != null && model.additionalData != null)
                ..._buildTagWidgets(context, model.tag, model.additionalData)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTagWidgets(BuildContext context, NfcTag tag, Map additionalData) {
    final tagWidgets = <Widget>[];
    final ndefWidgets = <Widget>[];

    if (Platform.isAndroid) {
      tagWidgets.add(ListCell(
        title: Text('Identifier'),
        subtitle: Text(hexFromBytes(
          NfcA.from(tag)?.identifier ??
          NfcB.from(tag)?.identifier ??
          NfcF.from(tag)?.identifier ??
          NfcV.from(tag)?.identifier
        )),
      ));
      tagWidgets.add(ListCell(
        title: Text('Tech List'),
        subtitle: Text(_getTechList(tag).join(' / ')),
      ));

      if (NfcA.from(tag) != null) {
        final nfca = NfcA.from(tag);
        tagWidgets.add(ListCell(
          title: Text('NfcA - Atqa'),
          subtitle: Text(hexFromBytes(nfca.atqa)),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcA - Sak'),
          subtitle: Text('${nfca.sak}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcA - Max Transceive Length'),
          subtitle: Text('${nfca.maxTransceiveLength}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcA - Timeout'),
          subtitle: Text('${nfca.timeout}'),
        ));

        if (MifareClassic.from(tag) != null) {
          final mifareclassic = MifareClassic.from(tag);
          tagWidgets.add(ListCell(
            title: Text('MifareClassic - Type'),
            subtitle: Text(_getMiFareClassicType(mifareclassic.type)),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareClassic - Size'),
            subtitle: Text('${mifareclassic.size}'),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareClassic - Sector Count'),
            subtitle: Text('${mifareclassic.sectorCount}'),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareClassic - Block Count'),
            subtitle: Text('${mifareclassic.blockCount}'),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareClassic - Max Transceive Length'),
            subtitle: Text('${mifareclassic.maxTransceiveLength}'),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareClassic - Timeout'),
            subtitle: Text('${mifareclassic.timeout}'),
          ));
        }

        if (MifareUltralight.from(tag) != null) {
          final mifareultralight = MifareUltralight.from(tag);
          tagWidgets.add(ListCell(
            title: Text('MifareUltralight - Type'),
            subtitle: Text(_getMiFareUltralightType(mifareultralight.type)),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareUltralight - Max Transceive Length'),
            subtitle: Text('${mifareultralight.maxTransceiveLength}'),
          ));
          tagWidgets.add(ListCell(
            title: Text('MifareUltralight - Timeout'),
            subtitle: Text('${mifareultralight.timeout}'),
          ));
        }
      }

      if (NfcB.from(tag) != null) {
        final nfcb = NfcB.from(tag);
        tagWidgets.add(ListCell(
          title: Text('NfcB - Application Data'),
          subtitle: Text(hexFromBytes(nfcb.applicationData)),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcB - Protocol Info'),
          subtitle: Text(hexFromBytes(nfcb.protocolInfo)),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcB - Max Transceive Length'),
          subtitle: Text('${nfcb.maxTransceiveLength}'),
        ));
      }

      if (NfcF.from(tag) != null) {
        final nfcf = NfcF.from(tag);
        tagWidgets.add(ListCell(
          title: Text('NfcF - System Code'),
          subtitle: Text(hexFromBytes(nfcf.systemCode)),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcF - Manufacturer'),
          subtitle: Text(hexFromBytes(nfcf.manufacturer)),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcF - Max Transceive Length'),
          subtitle: Text('${nfcf.maxTransceiveLength}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcF - Timeout'),
          subtitle: Text('${nfcf.timeout}'),
        ));
      }

      if (NfcV.from(tag) != null) {
        final nfcv = NfcV.from(tag);
        tagWidgets.add(ListCell(
          title: Text('NfcV - DsfId'),
          subtitle: Text('${nfcv.dsfId}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcV - Response Flags'),
          subtitle: Text('${nfcv.responseFlags}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('NfcV - Max Transceive Length'),
          subtitle: Text('${nfcv.maxTransceiveLength}'),
        ));
      }

      if (IsoDep.from(tag) != null) {
        final isodep = IsoDep.from(tag);
        tagWidgets.add(ListCell(
          title: Text('IsoDep - Hi Layer Response'),
          subtitle: Text(hexFromBytes(isodep.hiLayerResponse)),
        ));
        tagWidgets.add(ListCell(
          title: Text('IsoDep - Historical Bytes'),
          subtitle: Text(hexFromBytes(isodep.historicalBytes)),
        ));
        tagWidgets.add(ListCell(
          title: Text('IsoDep - Extended Length Apdu Supported'),
          subtitle: Text('${isodep.isExtendedLengthApduSupported}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('IsoDep - Max Transceive Length'),
          subtitle: Text('${isodep.maxTransceiveLength}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('IsoDep - Timeout'),
          subtitle: Text('${isodep.timeout}'),
        ));
      }
    }

    if (Platform.isIOS) {
      if (FeliCa.from(tag) != null) {
        final felica = FeliCa.from(tag);
        final manufacturerParameter = additionalData['manufacturerParameter'] as Uint8List;
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('FeliCa'),
        ));
        tagWidgets.add(ListCell(
          title: Text('Current IDm'),
          subtitle: Text(hexFromBytes(felica.currentIDm)),
        ));
        tagWidgets.add(ListCell(
          title: Text('Current System Code'),
          subtitle: Text(hexFromBytes(felica.currentSystemCode)),
        ));
        tagWidgets.add(ListCell(
          title: Text('Manufacturer Parameter'),
          subtitle: Text(hexFromBytes(manufacturerParameter)),
        ));
      }

      if (Iso15693.from(tag) != null) {
        final iso15693 = Iso15693.from(tag);
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('ISO15693'),
        ));
        tagWidgets.add(ListCell(
          title: Text('Identifier'),
          subtitle: Text(hexFromBytes(iso15693.identifier)),
        ));
        tagWidgets.add(ListCell(
          title: Text('IC Serial Number'),
          subtitle: Text(hexFromBytes(iso15693.icSerialNumber)),
        ));
        tagWidgets.add(ListCell(
          title: Text('IC Manufacturer Code'),
          subtitle: Text('${iso15693.icManufacturerCode}'),
        ));
      }

      if (Iso7816.from(tag) != null) {
        final iso7816 = Iso7816.from(tag);
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('ISO7816'),
        ));
        tagWidgets.add(ListCell(
          title: Text('Identifier'),
          subtitle: Text(hexFromBytes(iso7816.identifier)),
        ));
        tagWidgets.add(ListCell(
          title: Text('Initial Selected AID'),
          subtitle: Text('${iso7816.initialSelectedAID}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('Application Data'),
          subtitle: Text(hexFromBytes(iso7816.applicationData)),
        ));
        tagWidgets.add(ListCell(
          title: Text('Historical Bytes'),
          subtitle: Text(hexFromBytes(iso7816.historicalBytes)),
        ));
        tagWidgets.add(ListCell(
          title: Text('Proprietary Application Data Coding'),
          subtitle: Text('${iso7816.proprietaryApplicationDataCoding}'),
        ));
      }

      if (MiFare.from(tag) != null) {
        final mifare = MiFare.from(tag);
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('MiFare ${_getMiFareFamily(mifare.mifareFamily)}'),
        ));
        tagWidgets.add(ListCell(
          title: Text('Identifier'),
          subtitle: Text(hexFromBytes(mifare.identifier)),
        ));
        tagWidgets.add(ListCell(
          title: Text('Historical Bytes'),
          subtitle: Text(hexFromBytes(mifare.historicalBytes)),
        ));
      }
    }

    if (Ndef.from(tag) != null) {
      final ndef = Ndef.from(tag);
      final canMakeReadOnly = ndef.additionalData['canMakeReadOnly'] as bool;
      final type = ndef.additionalData['type'] as String;
      if (type != null) ndefWidgets.add(ListCell(
        title: Text('Type'),
        subtitle: Text(_getNdefType(type)),
      ));
      ndefWidgets.add(ListCell(
        title: Text('Size'),
        subtitle: Text('${ndef.cachedMessage?.byteLength ?? 0} / ${ndef.maxSize} bytes'),
      ));
      ndefWidgets.add(ListCell(
        title: Text('Writable'),
        subtitle: Text('${ndef.isWritable}'),
      ));
      if (canMakeReadOnly != null) ndefWidgets.add(ListCell(
        title: Text('Can Make Read Only'),
        subtitle: Text('$canMakeReadOnly'),
      ));
      Iterable.generate(ndef.cachedMessage?.records?.length ?? 0).forEach((i) {
        final record = ndef.cachedMessage.records[i];
        final data = parseNdefRecord(record);
        ndefWidgets.add(ListCell(
          title: Text('#$i ${data['title']}'),
          subtitle: Text('${data['subtitle']}'),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, '/ndef_record', arguments: record),
        ));
      });
    }

    return [
      ListHeader(label: Text('TAG')),
      ListCellGroup(children: tagWidgets),
      if (ndefWidgets.isNotEmpty) ...[
        ListHeader(label: Text('NDEF')),
        ListCellGroup(children: ndefWidgets),
      ],
    ];
  }
}

List<String> _getTechList(NfcTag tag) {
  final techList = <String>[];
  if (tag.data.containsKey('nfca'))
    techList.add('NfcA');
  if (tag.data.containsKey('nfcb'))
    techList.add('NfcB');
  if (tag.data.containsKey('nfcf'))
    techList.add('NfcF');
  if (tag.data.containsKey('nfcv'))
    techList.add('NfcV');
  if (tag.data.containsKey('isodep'))
    techList.add('IsoDep');
  if (tag.data.containsKey('mifareclassic'))
    techList.add('MifareClassic');
  if (tag.data.containsKey('mifareultralight'))
    techList.add('MifareUltralight');
  if (tag.data.containsKey('ndef'))
    techList.add('Ndef');
  if (tag.data.containsKey('ndefformatable'))
    techList.add('NdefFormatable');
  return techList;
}

String _getMiFareClassicType(int code) {
  switch (code) {
    case 0:
      return 'Classic';
    case 1:
      return 'Plus';
    case 2:
      return 'Pro';
    default:
      return 'Unknown';
  }
}

String _getMiFareUltralightType(int code) {
  switch (code) {
    case 1:
      return 'Ultralight';
    case 2:
      return 'Ultralight C';
    default:
      return 'Unknown';
  }
}

String _getMiFareFamily(MiFareFamily family) {
  switch (family) {
    case MiFareFamily.unknown:
      return 'Unknown';
    case MiFareFamily.ultralight:
      return 'Ultralight';
    case MiFareFamily.plus:
      return 'Plus';
    case MiFareFamily.desfire:
      return 'Desfire';
    default:
      return 'Unknown';
  }
}

String _getNdefType(String code) {
  switch (code) {
    case 'org.nfcforum.ndef.type1':
      return 'NFC Forum Tag Type 1';
    case 'org.nfcforum.ndef.type2':
      return 'NFC Forum Tag Type 2';
    case 'org.nfcforum.ndef.type3':
      return 'NFC Forum Tag Type 3';
    case 'org.nfcforum.ndef.type4':
      return 'NFC Forum Tag Type 4';
    default:
      return 'Unknown';
  }
}
