import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image/image.dart' as img;
import 'package:image_compression/image_compression.dart';
import 'package:desktop_drop/desktop_drop.dart';

import '../../app/locator.dart';
import '../../data/models/site.dart';
import '../../services/firestore_service.dart';
import '../../utilitiies/blur_hash_isolate.dart';
import 'site_screen.dart';

class SiteScreenVM extends ChangeNotifier {
  final _firestore = locator<FirestoreService>();

  final formKey = GlobalKey<FormState>();

  final SiteScreenArguments? args;
  SiteScreenVM(this.args);

  final numbController = TextEditingController();
  final nameController = TextEditingController();
  final townController = TextEditingController();
  final descController = TextEditingController();

  final mapController = MapController();

  late Site site;

  bool loading = true;

  Future<void> init() async {
    final id = args?.siteId;
    if (id != null) {
      await loadExistingSite(id);
    } else {
      loadEmptySide();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadExistingSite(String id) async {
    site = await _firestore.fetchSite(id);
    numbController.text = site.siteNumber;
    nameController.text = site.info.name;
    townController.text = site.info.town;
    descController.text = site.info.description;
  }

  void loadEmptySide() {
    site = Site.empty();
  }

  void onDispose() {}

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> createSite() async {
    formKey.currentState!.validate();
  }

  bool imageUploading = false;

  Future<void> pickFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final File file = File(result.files.single.path!);
      await uploadImage(
        await file.readAsBytes(),
        file.path,
      );
    }
  }

  Future<void> dragFiles(DropDoneDetails detail) async {
    final files = detail.files;
    for (final element in files) {
      await uploadImage(
        await element.readAsBytes(),
        element.path,
      );
    }
  }

  Future<void> uploadImage(Uint8List data, String filePath) async {
    try {
      imageUploading = true;
      notifyListeners();

      final compressedData = compress(
        ImageFileConfiguration(
          input: ImageFile(
            rawBytes: data,
            filePath: filePath,
          ),
        ),
      );

      final bytes = compressedData.rawBytes;

      final url = await _firestore.uploadImage(
        imageBytes: bytes,
        folderName: site.uid,
      );

      if (url == null) {
        throw Exception('Image upload failed');
      }

      final ReceivePort port = ReceivePort();
      final isolate = await Isolate.spawn<List<dynamic>>(
        calculateBlurHash,
        [port.sendPort, bytes],
      );
      final hash = await port.first as String;
      isolate.kill(priority: Isolate.immediate);

      site.images.add(
        SiteImage(hash, url),
      );
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      imageUploading = false;
      notifyListeners();
    }
  }

  void deleteImage(SiteImage image) {
    site.images.removeWhere((element) => element.url == image.url);
    notifyListeners();
  }
}
