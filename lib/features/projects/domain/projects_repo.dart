import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/project_model.dart';

class ProjectsRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<List<ProjectModel>> getProjectsByRole(String role) {
    final uid = _firebaseAuth.currentUser?.uid;

    try {
      if (role == "manager") {
        return _firestore
            .collection("projects")
            .where("managerId", isEqualTo: uid)
            .snapshots()
            .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProjectModel.fromJson(doc.data(), doc.id))
              .toList();
        });
      }
      else if ( role == "user") {
        return _firestore
            .collection("projects")
            .where("employeeIds", arrayContains: uid)
            .snapshots()
            .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProjectModel.fromJson(doc.data(), doc.id))
              .toList();
        });
      } else {
        return _firestore
            .collection("projects")
            .snapshots()
            .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProjectModel.fromJson(doc.data(), doc.id))
              .toList();
        });

      }
    } catch (e) {
      debugPrint("Error getting projects ${e.toString()}");
      rethrow;
    }
  }
  Future<void> createProject(ProjectModel projectModel) async {
    try {
      await _firestore
          .collection("projects")
          .add(
            projectModel
                .copyWith(managerId: _firebaseAuth.currentUser?.uid)
                .toJson(),
          );
    } catch (e) {
      debugPrint("There an error during creating project ${e.toString()}");
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      _firestore.collection("projects").doc(projectId).delete();
    } catch (e) {
      debugPrint("There an error deleting project ${e.toString()}");
    }
  }

  Future<void> updateProject(ProjectModel projectModel) async {
    try {
      _firestore
          .collection("projects")
          .doc(projectModel.id)
          .update(projectModel.toJson());
    } catch (e) {
      debugPrint("There an error updating project ${e.toString()}");
    }
  }

  Future<void> addEmployeeToProject(String projectId, String employeeId) async {
    try {
      _firestore.collection("projects").doc(projectId).update({
        "employeeIds": FieldValue.arrayUnion([employeeId]),
      });
    } catch (e) {
      debugPrint("There an error adding employee to project");
    }
  }
}
