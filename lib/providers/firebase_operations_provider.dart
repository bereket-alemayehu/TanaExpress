import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/firebase_model/firebase_operations.dart';

final firebaseOperationsProvider = Provider<FirebaseOperations>((ref) {
  return FirebaseOperations();
});
