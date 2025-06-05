class UserModel {
  String id;
  String fullName;
  String email;
  String phone;
  String location;
  String password;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.password,
  });

  // Convert a UserModel instance to a Map for Firestore or Firebase Realtime Database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'password': password,
    };
  }

  // Create a UserModel instance from a JSON object (Map)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
