
class UserModel {
  String uid;
  String name;
  String email;
  String gender;
  int age;
  double height;  // in cm
  double weight;  // in kg
  String activityLevel;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'] ?? '',
      age: data['age'] ?? 0,
      height: (data['height'] ?? 0).toDouble(),
      weight: (data['weight'] ?? 0).toDouble(),
      activityLevel: data['activityLevel'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
    };
  }
  bool get isComplete {
    return name.isNotEmpty &&
        gender.isNotEmpty &&
        age > 0 &&
        height > 0 &&
        weight > 0 &&
        activityLevel.isNotEmpty;
  }
}