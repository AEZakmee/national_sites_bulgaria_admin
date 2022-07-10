import 'dart:isolate';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as img;

void calculateBlurHash(List<dynamic> values) {
  final SendPort sendPort = values[0];
  final Uint8List data = values[1];
  final image = img.decodeImage(data.toList());
  final blurHash = BlurHash.encode(image!);
  sendPort.send(blurHash.hash);
}
