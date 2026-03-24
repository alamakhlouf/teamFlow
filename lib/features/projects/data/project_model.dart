import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String managerId;
  final List<String> employeeIds;
  final DateTime createdAt;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.managerId,
    required this.employeeIds,
    required this.createdAt,
  });

  /// From Firestore
  factory ProjectModel.fromJson(Map<String, dynamic> json, String id) {
    return ProjectModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      managerId: json['managerId'] ?? '',
      employeeIds: List<String>.from(json['employeeIds'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'managerId': managerId,
      'employeeIds': employeeIds,
      'createdAt': createdAt,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? managerId,
    List<String>? employeeIds,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      managerId: managerId ?? this.managerId,
      employeeIds: employeeIds ?? this.employeeIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}