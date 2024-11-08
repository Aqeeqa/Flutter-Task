class Human {
  final int id;
  final String name;
  final String details;

  Human({required this.id, required this.name, required this.details});

  factory Human.fromJson(Map<String, dynamic> json) {
    return Human(
      id: json['id'],
      name: json['name'],
      details: json['details'],
    );
  }
}
