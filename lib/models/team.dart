import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A named lineup of deployed Dreamkeepers. Mirrors GameCore/Models/Team.swift.
class Team {
  static const maxSize = 4;

  final String id;
  final String name;
  final List<String> memberIDs;

  Team({String? id, this.name = 'Main Team', List<String>? memberIDs})
      : id = id ?? _uuid.v4(),
        memberIDs = memberIDs ?? [];

  Team copyWith({String? name, List<String>? memberIDs}) => Team(
        id: id,
        name: name ?? this.name,
        memberIDs: memberIDs ?? this.memberIDs,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'memberIDs': memberIDs,
      };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'] as String,
        name: json['name'] as String,
        memberIDs: (json['memberIDs'] as List).cast<String>(),
      );
}
