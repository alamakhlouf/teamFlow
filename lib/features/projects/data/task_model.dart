import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final String status;
  final String? assignedTo;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    this.assignedTo,
    required this.createdAt,
  });

  /// From Firestore
  factory TaskModel.fromJson(
      Map<String, dynamic> json,
      String id,
      String projectId,
      ) {
    return TaskModel(
      id: id,
      projectId: projectId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'todo',
      assignedTo: json['assignedTo'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// To Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'assignedTo': assignedTo,
      'createdAt': createdAt,
    };
  }

  /// copyWith
  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    String? status,
    String? assignedTo,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}