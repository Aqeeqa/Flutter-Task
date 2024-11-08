class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // A method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()) ?? 0, // Ensure id is an integer
      name: json['name'] ?? 'Unknown', // Handle missing or null name
      email: json['email'] ?? 'Unknown', // Handle missing or null email
    );
  }
}
