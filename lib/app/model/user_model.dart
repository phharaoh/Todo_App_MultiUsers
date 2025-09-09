class UserModel {
  final String email;
  final String specialData;

  UserModel({required this.email, required this.specialData});

  Map<String, dynamic> toJson() => {'email': email, 'specialData': specialData};

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(email: json['email'], specialData: json['specialData']);
}
