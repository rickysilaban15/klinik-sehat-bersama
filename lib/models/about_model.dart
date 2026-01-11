class AboutContent {
  final String id;
  String title;
  String content;
  String mission;
  String vision;
  List<TeamMember> team;
  DateTime updatedAt;

  AboutContent({
    required this.id,
    required this.title,
    required this.content,
    required this.mission,
    required this.vision,
    required this.team,
    required this.updatedAt,
  });

  factory AboutContent.fromJson(Map<String, dynamic> json) {
    return AboutContent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mission: json['mission'] ?? '',
      vision: json['vision'] ?? '',
      team: List<TeamMember>.from(
        (json['team'] ?? []).map((x) => TeamMember.fromJson(x)),
      ),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mission': mission,
      'vision': vision,
      'team': team.map((x) => x.toJson()).toList(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TeamMember {
  final String id;
  String name;
  String position;
  String bio;
  String photo;

  TeamMember({
    required this.id,
    required this.name,
    required this.position,
    required this.bio,
    required this.photo,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      bio: json['bio'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'bio': bio,
      'photo': photo,
    };
  }
}