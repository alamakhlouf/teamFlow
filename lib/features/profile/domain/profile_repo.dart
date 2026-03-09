import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_flow/features/profile/data/profile_model.dart';

class ProfileRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileModel> getProfile() async {
    try {
      final user = _firebaseAuth.currentUser;
      final userDetails = await _firestore
          .collection("users")
          .doc(user!.uid)
          .get();
      final managerName = await _firestore
          .collection("users")
          .doc(userDetails.data()!["managerId"])
          .get();
      ProfileModel profileModel = ProfileModel.fromJson(userDetails.data()!);
      profileModel = profileModel.copyWith(
        managerName: managerName.data()?["displayName"],
      );
      return profileModel;
    } catch (e) {
      debugPrint("There an error during getting profile ${e.toString()}");
      rethrow;
    }
  }
}
