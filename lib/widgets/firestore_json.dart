import 'package:firedart/firedart.dart';

DocumentReference firebaseDocRefFromJson(dynamic value) {
  if (value is DocumentReference) {
    return Firestore.instance.document(value.path);
  }
  return Firestore.instance.document(value);
}

String firebaseDocRefToJson(DocumentReference ref) => ref.path;
