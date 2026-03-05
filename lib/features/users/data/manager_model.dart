class ManagerModel {
  final String uid;
  final String displayName;

  ManagerModel({
    required this.uid,
    required this.displayName,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
    };
  }

  ManagerModel copyWith({
    String? uid,
    String? displayName,
  }) {
    return ManagerModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  String toString() {
    return 'ManagerModel(uid: $uid, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ManagerModel &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              displayName == other.displayName;

  @override
  int get hashCode => uid.hashCode ^ displayName.hashCode;
}