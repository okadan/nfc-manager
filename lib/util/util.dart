import 'dart:typed_data';

String hexFromBytes(Uint8List bytes, {String separator = ' ', String empty = '-'}) {
  return bytes == null || bytes.isEmpty
    ? empty
    : bytes.map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join(separator);
}
