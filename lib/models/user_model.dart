// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final int level;
  final int exp;
  final String rank;
  final List<String> hobbyTags;
  final bool notificationEnabled;
  final String reminderTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    this.name = '',
    this.level = 1,
    this.exp = 0,
    this.rank = '見習い冒険者',
    this.hobbyTags = const [],
    this.notificationEnabled = true,
    this.reminderTime = '18:00',
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      level: (map['level'] as num?)?.toInt() ?? 1,
      exp: (map['exp'] as num?)?.toInt() ?? 0,
      rank: map['rank'] as String? ?? '見習い冒険者',
      hobbyTags: List<String>.from(map['hobbyTags'] as List? ?? const []),
      notificationEnabled: map['notificationEnabled'] as bool? ?? true,
      reminderTime: map['reminderTime'] as String? ?? '18:00',
      createdAt: _dateTimeFromMap(map['createdAt']),
      updatedAt: _dateTimeFromMap(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'exp': exp,
      'rank': rank,
      'hobbyTags': hobbyTags,
      'notificationEnabled': notificationEnabled,
      'reminderTime': reminderTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    int? level,
    int? exp,
    String? rank,
    List<String>? hobbyTags,
    bool? notificationEnabled,
    String? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      rank: rank ?? this.rank,
      hobbyTags: hobbyTags ?? this.hobbyTags,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _dateTimeFromMap(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return (value as dynamic).toDate() as DateTime;
  }
}
