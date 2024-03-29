import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_compression/image_compression.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../app/locator.dart';
import '../../data/models/site.dart';
import '../../services/firestore_service.dart';
import '../../utilitiies/blur_hash_isolate.dart';
import 'site_screen.dart';

enum SubmitResponse {
  success,
  fail,
  errorFields,
}

class SiteScreenVM extends ChangeNotifier {
  final FirestoreService _firestore;

  final formKey = GlobalKey<FormState>();

  late final SiteScreenArguments? args;

  final numbController = TextEditingController();
  final nameController = TextEditingController();
  final townController = TextEditingController();
  final descController = TextEditingController();

  final mapController = MapController();

  latlong.LatLng? point;

  late Site site;
  bool newSite = true;

  bool loading = true;
  bool error = false;

  SiteScreenVM({required firestore}) : _firestore = firestore;

  Future<void> init(SiteScreenArguments? arguments) async {
    args = arguments;
    final id = args?.siteId;
    if (id != null) {
      newSite = false;
      await loadExistingSite(id);
    } else {
      loadEmptySide();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadExistingSite(String id) async {
    final response = await _firestore.fetchSite(id);
    if (response.success) {
      site = response.data;
      numbController.text = site.siteNumber;
      nameController.text = site.info.name;
      townController.text = site.info.town;
      descController.text = site.info.description;
      point = latlong.LatLng(site.coordinates.lat, site.coordinates.lng);
    } else {
      error = true;
    }
  }

  void loadEmptySide() {
    site = Site.empty();
  }

  void onDispose() {}

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<SubmitResponse> submit() async {
    SubmitResponse response = SubmitResponse.fail;
    final formsValid = formKey.currentState!.validate();
    final mapValid = point != null;
    final imagesValid = site.images.isNotEmpty;
    if (formsValid && mapValid && imagesValid) {
      site.info.name = nameController.text;
      site.info.town = townController.text;
      site.info.description = descController.text;

      site
        ..siteNumber = numbController.text
        ..coordinates = Coordinates(point!.latitude, point!.longitude);

      try {
        await _firestore.createSite(site);
        response = SubmitResponse.success;
      } on Exception catch (e) {
        log(e.toString());
      }
    } else {
      response = SubmitResponse.errorFields;
    }

    return response;
  }

  bool imageUploading = false;

  void mapClick(latlong.LatLng position) {
    point = position;
    notifyListeners();
  }

  void clearMap() {
    point = null;
    notifyListeners();
  }

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
