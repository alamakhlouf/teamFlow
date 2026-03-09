class ProfileModel {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String? managerName;

  const ProfileModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.managerName,
  });

  /// From Firestore / JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      managerName: json['managerName'],
    );
  }

  /// To Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'managerName': managerName,
    };
  }

  /// copyWith
  ProfileModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    bool? firstLogin,
    String? managerName,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      managerName: managerName ?? this.managerName,
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, role: $role, managerId: $managerName)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileModel &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              email == other.email &&
              displayName == other.displayName &&
              role == other.role ;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      role.hashCode ;
}
