import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/model/record.dart';
import 'package:flutter_nfc_manager/view/widgets/list.dart';
import 'package:flutter_nfc_manager/view/widgets/nfc_session.dart';
import 'package:flutter_nfc_manager/viewmodel/tag_read.dart';
import 'package:flutter_nfc_manager/util/extensions.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

class TagReadPage extends StatelessWidget {
  static Widget create() => Provider<TagReadModel>(
    create: (context) => TagReadModel(),
    child: TagReadPage(),
  );

  @override
  Widget build(BuildContext context) {
    final TagReadModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Tag - Read')),
      body: SafeArea(
        child: ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: model.dataNotifier,
          builder: (context, value, child) => ListView(
            padding: EdgeInsets.all(2),
            children: [
              ListCellGroup(children: [
                ListCellButton(
                  title: Text('Start a scan'),
                  onTap: () => startTagSession(context: context, handleTag: model.handleTag),
                ),
              ]),
              if (value != null)
                _buildTagInfo(context, value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagInfo(BuildContext context, Map<String, dynamic> data) {
    final List<Widget> tagWidgets = [];
    final List<Widget> ndefWidgets = [];
    if (Platform.isAndroid) {
      final Uint8List identifier = data['identifier'];
      final List<String> techList = _getTechList(data);
      if (techList.isNotEmpty)
        tagWidgets.add(ListCell(
          title: Text('Tech List'),
          subtitle: Text('${techList.join('/')}'),
        ));
      if (identifier != null)
        tagWidgets.add(ListCell(
          title: Text('Identifier'),
          subtitle: Text('${identifier.toHexString()}'),
        ));
      if (data['nfca'] != null) {
        final Map<String, dynamic> d = Map<String, dynamic>.from(data['nfca']);
        final Uint8List atqa = d['atqa'];
        final int sak = d['sak'];
        final int maxTransceiveLength = d['maxTransceiveLength'];
        final int timeout = d['timeout'];
        if (atqa != null)
          tagWidgets.add(ListCell(
            title: Text('Atqa'),
            subtitle: Text('${atqa.toHexString()}'),
          ));
        if (sak != null)
          tagWidgets.add(ListCell(
            title: Text('Sak'),
            subtitle: Text('$sak'),
          ));
        if (maxTransceiveLength != null)
          tagWidgets.add(ListCell(
            title: Text('Max Transceive Length'),
            subtitle: Text('$maxTransceiveLength'),
          ));
        if (timeout != null)
          tagWidgets.add(ListCell(
            title: Text('Timeout'),
            subtitle: Text('$timeout'),
          ));
        if (data['mifareclassic'] != null) {
          final Map<String, dynamic> dd = Map<String, dynamic>.from(data['mifareclassic']);
          final int blockCount = dd['blockCount'];
          final int sectorCount = dd['sectorCount'];
          final int type = dd['type'];
          final int size = dd['size'];
          if (type != null)
            tagWidgets.add(ListCell(
              title: Text('Type'),
              subtitle: Text('$type'),
            ));
          if (size != null)
            tagWidgets.add(ListCell(
              title: Text('Size'),
              subtitle: Text('$size'),
            ));
          if (blockCount != null)
            tagWidgets.add(ListCell(
              title: Text('Block Count'),
              subtitle: Text('$blockCount'),
            ));
          if (sectorCount != null)
            tagWidgets.add(ListCell(
              title: Text('Sector Count'),
              subtitle: Text('$sectorCount'),
            ));
        }
        if (data['mifareultralight'] != null) {
          final Map<String, dynamic> dd = Map<String, dynamic>.from(data['mifareultralight']);
          final int type = dd['type'];
          if (type != null)
            tagWidgets.add(ListCell(
              title: Text('Type'),
              subtitle: Text('$type'),
            ));
        }
      }
      if (data['nfcb'] != null) {
        final Map<String, dynamic> d = Map<String, dynamic>.from(data['nfcb']);
        final Uint8List applicationData = d['applicationData'];
        final Uint8List protocolInfo = d['protocolInfo'];
        final int maxTransceiveLength = d['maxTransceiveLength'];
        if (applicationData != null)
          tagWidgets.add(ListCell(
            title: Text('Application Data'),
            subtitle: Text('${applicationData.toHexString()}'),
          ));
        if (protocolInfo != null)
          tagWidgets.add(ListCell(
            title: Text('Protocol Info'),
            subtitle: Text('${protocolInfo.toHexString()}'),
          ));
        if (maxTransceiveLength != null)
          tagWidgets.add(ListCell(
            title: Text('Max Transceive Length'),
            subtitle: Text('$maxTransceiveLength'),
          ));
      }
      if (data['nfcf'] != null) {
        final Map<String, dynamic> d = Map<String, dynamic>.from(data['nfcf']);
        final Uint8List systemCode = d['systemCode'];
        final Uint8List manufacturer = d['manufacturer'];
        final int maxTransceiveLength = d['maxTransceiveLength'];
        final int timeout = data['timeout'];
        if (systemCode != null)
          tagWidgets.add(ListCell(
            title: Text('System Code'),
            subtitle: Text('${systemCode.toHexString()}'),
          ));
        if (manufacturer != null)
          tagWidgets.add(ListCell(
            title: Text('Manufacturer'),
            subtitle: Text('${manufacturer.toHexString()}'),
          ));
        if (maxTransceiveLength != null)
          tagWidgets.add(ListCell(
            title: Text('Max Transceive Length'),
            subtitle: Text('$maxTransceiveLength'),
          ));
        if (timeout != null)
          tagWidgets.add(ListCell(
            title: Text('Timeout'),
            subtitle: Text('$timeout'),
          ));
      }
      if (data['nfcv'] != null) {
        final Map<String, dynamic> d = Map<String, dynamic>.from(data['nfcv']);
        final int dsfId = d['dsfId'];
        final int responseFlags = d['responseFlags'];
        final int maxTransceiveLength = d['maxTransceiveLength'];
        if (dsfId != null)
          tagWidgets.add(ListCell(
            title: Text('DSFID'),
            subtitle: Text('$dsfId'),
          ));
        if (responseFlags != null)
          tagWidgets.add(ListCell(
            title: Text('Response Flags'),
            subtitle: Text('$responseFlags'),
          ));
        if (maxTransceiveLength != null)
          tagWidgets.add(ListCell(
            title: Text('Max Transceive Length'),
            subtitle: Text('$maxTransceiveLength'),
          ));
      }
      if (data['isodep'] != null) {
        final Map<String, dynamic> d = Map<String, dynamic>.from(data['isodep']);
        final Uint8List hiLayerResponse = d['hiLayerResponse'];
        final Uint8List historicalBytes = d['historicalBytes'];
        final bool isExtendedLengthApduSupported = d['isExtendedLengthApduSupported'];
        final int maxTransceiveLength = d['maxTransceiveLength'];
        final int timeout = d['timeout'];
        if (hiLayerResponse != null)
          tagWidgets.add(ListCell(
            title: Text('Hi Layer Response'),
            subtitle: Text('${hiLayerResponse.toHexString()}'),
          ));
        if (historicalBytes != null)
          tagWidgets.add(ListCell(
            title: Text('Historical Bytes'),
            subtitle: Text('${historicalBytes.toHexString()}'),
          ));
        if (isExtendedLengthApduSupported != null)
          tagWidgets.add(ListCell(
            title: Text('Is Extended Length Apdu Supported'),
            subtitle: Text('$isExtendedLengthApduSupported'),
          ));
        if (maxTransceiveLength != null)
          tagWidgets.add(ListCell(
            title: Text('Max Transceive Length'),
            subtitle: Text('$maxTransceiveLength'),
          ));
        if (timeout != null)
          tagWidgets.add(ListCell(
            title: Text('Timeout'),
            subtitle: Text('$timeout'),
          ));
      }
    }

    if (Platform.isIOS) {
      if (data['type'] == 'miFare') {
        final int family = data['mifareFamily'];
        final Uint8List historicalBytes = data['historicalBytes'];
        final Uint8List identifier = data['identifier'];
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('MiFare ' + (
            family == 2 ? 'Ultralight' :
            family == 3 ? 'Plus' :
            family == 4 ? 'Desfire' :
            'Unknown'
          )),
        ));
        if (identifier != null)
          tagWidgets.add(ListCell(
            title: Text('Identifier'),
            subtitle: Text(identifier.toHexString()),
          ));
        if (historicalBytes != null)
          tagWidgets.add(ListCell(
            title: Text('Historical Bytes'),
            subtitle: Text(historicalBytes.toHexString()),
          ));
      }
      if (data['type'] == 'feliCa') {
        final Uint8List currentSystemCode = data['currentSystemCode'];
        final Uint8List currentIDm = data['currentIDm'];
        final Uint8List pmm = data['pmm'];
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('FeliCa'),
        ));
        if (currentSystemCode != null)
          tagWidgets.add(ListCell(
            title: Text('Current System Code'),
            subtitle: Text(currentSystemCode.toHexString()),
          ));
        if (currentIDm != null)
          tagWidgets.add(ListCell(
            title: Text('Current IDm'),
            subtitle: Text(currentIDm.toHexString()),
          ));
        if (pmm != null)
          tagWidgets.add(ListCell(
            title: Text('PMm'),
            subtitle: Text(pmm.toHexString()),
          ));
      }
      if (data['type'] == 'iso7816') {
        final Uint8List identifier = data['identifier'];
        final String initialSelectedAID = data['initialSelectedAID'];
        final Uint8List applicationData = data['applicationData'];
        final Uint8List historicalBytes = data['historicalBytes'];
        final bool proprietaryApplicationDataCoding = data['proprietaryApplicationDataCoding'];
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('ISO7816'),
        ));
        if (identifier != null)
          tagWidgets.add(ListCell(
            title: Text('Identifier'),
            subtitle: Text(identifier.toHexString()),
          ));
        if (initialSelectedAID != null)
          tagWidgets.add(ListCell(
            title: Text('Initial Selected AID'),
            subtitle: Text(initialSelectedAID),
          ));
        if (historicalBytes != null)
          tagWidgets.add(ListCell(
            title: Text('Historical Bytes'),
            subtitle: Text(historicalBytes.toHexString()),
          ));
        if (applicationData != null)
          tagWidgets.add(ListCell(
            title: Text('Application Data'),
            subtitle: Text(applicationData.toHexString()),
          ));
        if (proprietaryApplicationDataCoding != null)
          tagWidgets.add(ListCell(
            title: Text('Proprietary Application Data Coding'),
            subtitle: Text('$proprietaryApplicationDataCoding'),
          ));
      }
      if (data['type'] == 'iso15693') {
        final Uint8List identifier = data['identifier'];
        final Uint8List icSerialNumber = data['icSerialNumber'];
        final int icManufacturerCode = data['icManufacturerCode'];
        tagWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('ISO15693'),
        ));
        if (identifier != null)
          tagWidgets.add(ListCell(
            title: Text('Identifier'),
            subtitle: Text(identifier.toHexString()),
          ));
        if (icSerialNumber != null)
          tagWidgets.add(ListCell(
            title: Text('Serial Number'),
            subtitle: Text(icSerialNumber.toHexString()),
          ));
        if (icManufacturerCode != null)
          tagWidgets.add(ListCell(
            title: Text('Manufacturer Code'),
            subtitle: Text('$icManufacturerCode'),
          ));
      }
    }

    if (data['ndef'] != null) {
      final Map<String, dynamic> ndefData = Map<String, dynamic>.from(data['ndef']);
      final String type = ndefData['type'];
      final int maxSize = ndefData['maxSize'];
      final bool isWritable = ndefData['isWritable'];
      final bool canMakeReadOnly = ndefData['canMakeReadOnly'];
      final NdefMessage cachedMessage = ndefData['cachedMessage'] == null
        ? null : NdefMessage((ndefData['cachedMessage']['records'] as List).map((e) => NdefRecord(
          typeNameFormat: e['typeNameFormat'],
          type: e['type'],
          identifier: e['identifier'],
          payload: e['payload'],
        )).toList());
      if (type != null)
        ndefWidgets.add(ListCell(
          title: Text('Type'),
          subtitle: Text('$type'),
        ));
      if (maxSize != null)
        ndefWidgets.add(ListCell(
          title: Text('Size'),
          subtitle: Text('${cachedMessage?.byteLength ?? 0} / $maxSize bytes'),
        ));
      if (isWritable != null)
        ndefWidgets.add(ListCell(
          title: Text('Writable'),
          subtitle: Text('$isWritable'),
        ));
      if (canMakeReadOnly != null)
        ndefWidgets.add(ListCell(
          title: Text('Can Make Read Only'),
          subtitle: Text('$canMakeReadOnly'),
        ));
      if (cachedMessage != null)
        List.generate(cachedMessage.records.length, (i) => i).forEach((i) {
          final NdefRecord record = cachedMessage.records[i];
          final Map<String, dynamic> data = parseNdefRecord(record);
          ndefWidgets.add(ListCell(
            title: Text('#$i ${data['title']}'),
            subtitle: Text('${data['subtitle']}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/ndef_record', arguments: record),
          ));
        });
    }

    return Column(
      children: [
        ListCellGroup(children: tagWidgets),
        if (ndefWidgets.isNotEmpty) ...[
          ListCellGroup(children: ndefWidgets),
        ],
      ],
    );
  }
}

List<String> _getTechList(Map<String, dynamic> data) {
  final List<String> techList = [];
  if (data.containsKey('nfca'))
    techList.add('NfcA');
  if (data.containsKey('nfcb'))
    techList.add('NfcB');
  if (data.containsKey('nfcf'))
    techList.add('NfcF');
  if (data.containsKey('nfcv'))
    techList.add('NfcV');
  if (data.containsKey('isodep'))
    techList.add('IsoDep');
  if (data.containsKey('mifareclassic'))
    techList.add('MifareClassic');
  if (data.containsKey('mifareultralight'))
    techList.add('MifareUltralight');
  if (data.containsKey('ndef'))
    techList.add('Ndef');
  if (data.containsKey('ndefformattable'))
    techList.add('NdefFormattable');
  return techList;
}
