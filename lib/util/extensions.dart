import 'dart:typed_data';

extension Uint8ListExtension on Uint8List {
  String toHexString({String empty = '-'}) => this.isEmpty
    ? empty
    : this.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
    //: this.map((e) => '0x${e.toRadixString(16).padLeft(2, '0')}').join(' ');
    //: this.map((e) => '${e.toRadixString(16).padLeft(2, '0')}h').join(' ');
}
