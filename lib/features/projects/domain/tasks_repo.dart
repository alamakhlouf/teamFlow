import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/task_model.dart';

class TasksRepo {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTaskToProject(String projectId, TaskModel task) async {
    try {
      await _firestore
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .add(task.toJson());
    } catch (e) {
      debugPrint("There an error during creating project ${e.toString()}");
      rethrow;
    }
  }

  Future<void> assignTaskToEmployee(
      String projectId,
      String taskId,
      String employeeId,
      ) async {
    try {
      await _firestore
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .update({'assignedTo': employeeId});
    } catch (e) {
      debugPrint("There an error assigning task to project ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateTaskStatus(
      String projectId,
      String taskId,
      String status,
      ) async {
    try {
      await _firestore
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .update({'status': status});
    } catch (e) {
      debugPrint("There an error updating task status ${e.toString()}");
      rethrow;
    }
  }

  Future<void> deleteTask(String projectId, String taskId) async {
    try {
      _firestore
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .delete();
    } catch (e) {
      debugPrint("There an error deleting task ${e.toString()}");
    }
  }

  Future<void> updateTask(String projectId, TaskModel task) async {
    try {
      _firestore
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(task.id)
          .update(task.toJson());
    } catch (e) {
      debugPrint("There an error deleting task ${e.toString()}");
    }
  }

  Stream<List<TaskModel>> getTasks(String projectId) {
    try {
      return _firestore.collection("projects").doc(projectId).collection("tasks").snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => TaskModel.fromJson(doc.data(), doc.id, projectId)).toList();
      });
    } catch (e) {
      debugPrint("There an error during getting tasks ${e.toString()}");
      rethrow;
    }
  }
}