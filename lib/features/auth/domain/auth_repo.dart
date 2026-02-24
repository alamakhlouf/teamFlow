import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/app_user.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return await getUserDetails(userCredential.user!.uid);
    } catch (e) {
      debugPrint("There an error during login ${e.toString()}");
      rethrow;
    }
  }

  Future<AppUserModel> getUserDetails(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (doc.exists) {
      return AppUserModel.fromJson({...doc.data()!, 'uid': doc.id});
    } else {
      throw Exception("User not found");
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<AppUserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return await createUser(userCredential.user!, displayName, role);
    } catch (e) {
      debugPrint("There an error during registration ${e.toString()}");
      rethrow;
    }
  }

  Future<AppUserModel> createUser(
    User user,
    String displayName,
    String role,
  ) async {
    final AppUserModel appUserModel = AppUserModel(
      uid: user.uid,
      email: user.email ?? "",
      displayName: displayName,
      role: role,
      firstLogin: true,
    );
    await _firestore
        .collection("users")
        .doc(appUserModel.uid)
        .set(appUserModel.toJson());
    return appUserModel;
  }

  Future<void> changePassword(String newPassword) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        _firestore.collection("users").doc(user!.uid).update({
          "firstLogin": false,
        });
        await user.updatePassword(newPassword);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      debugPrint("There an error during password change ${e.toString()}");
      rethrow;
    }
  }
}
