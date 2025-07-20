class TrainerModel {
  String uid;
  String name;
  String email;
  String phone;
  String location;
  String bio;
  String photoUrl; // optional: for trainer profile photo

  TrainerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.bio,
    required this.photoUrl,
  });

  factory TrainerModel.fromMap(Map<String, dynamic> data) {
    return TrainerModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      bio: data['bio'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'photoUrl': photoUrl,
    };
  }
}
