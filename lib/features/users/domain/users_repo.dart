import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:team_flow/features/users/data/manager_model.dart';

import '../../auth/data/app_user.dart';

class UsersRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUserModel> registerWithEmailAndPassword(
    AppUserModel appUserModel,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: appUserModel.email,
            password: password,
          );
      return await createUser(
        userCredential.user!,
        appUserModel.displayName,
        appUserModel.role,
      );
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

  Stream<List<AppUserModel>> getUsers() {
    try {
      return _firestore
          .collection("users")
          .snapshots()
          .map(
            (event) =>
                event.docs.map((e) => AppUserModel.fromJson(e.data())).toList(),
          );
    } catch (e) {
      debugPrint("There an error during getting users ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateUser(AppUserModel appUserModel) async {
    try {
      await _firestore
          .collection("users")
          .doc(appUserModel.uid)
          .update(appUserModel.toJson());
    } catch (e) {
      debugPrint("There an error during updating user ${e.toString()}");
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      final usersRef = await _firestore.collection("users").doc(uid).get();
      if (usersRef.data()!["role"] == "manager") {
        final snapshot = await _firestore
            .collection("users")
            .where("managerId", isEqualTo: uid)
            .get();

        for (var doc in snapshot.docs) {
          await _firestore.collection("users").doc(doc.id).update({
            "managerId": null,
          });
        }
      }
      await _firestore.collection("users").doc(uid).delete();
    } catch (e) {
      debugPrint("There an error deleting user ${e.toString()}");
      rethrow;
    }
  }

  Stream<AppUserModel> getUser(String uid) {
    try {
      return _firestore
          .collection("users")
          .doc(uid)
          .snapshots()
          .map((event) => AppUserModel.fromJson(event.data()!));
    } catch (e) {
      debugPrint("There an error during getting user ${e.toString()}");
      rethrow;
    }
  }

  Stream<List<ManagerModel>> getAllManagers({String? excludeUid}) {
    try {
      return _firestore
          .collection("users")
          .where("role", isEqualTo: "manager")
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ManagerModel.fromJson(doc.data()))
                .where((manager) => manager.uid != excludeUid)
                .toList();
          });
    } catch (e) {
      debugPrint("There an error during getting managers ${e.toString()}");
      rethrow;
    }
  }
}
