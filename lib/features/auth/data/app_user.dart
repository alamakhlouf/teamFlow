class AppUserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String? managerId;
  final bool firstLogin;

  const AppUserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.firstLogin,
    this.managerId,
  });

  /// From Firestore / JSON
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      firstLogin: json['firstLogin'] as bool,
      managerId: json['managerId'],
    );
  }

  /// To Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'firstLogin': firstLogin,
      'managerId': managerId,
    };
  }

  /// copyWith
  AppUserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    bool? firstLogin,
    String? managerId,
  }) {
    return AppUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      firstLogin: firstLogin ?? this.firstLogin,
      managerId: managerId ?? this.managerId,
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, role: $role, firstLogin: $firstLogin, managerId: $managerId)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          role == other.role &&
          firstLogin == other.firstLogin;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      role.hashCode ^
      firstLogin.hashCode;
}
