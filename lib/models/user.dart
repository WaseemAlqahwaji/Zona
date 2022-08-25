class User {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? phone;
  String? gender;
  String? email;
  String? emailVerifiedAt;
  String? profileImage;
  String? verified;
  String? verificationCodes;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.name,
        this.phone,
        this.gender,
        this.email,
        this.emailVerifiedAt,
        this.profileImage,
        this.verified,
        this.verificationCodes,
        this.dateOfBirth,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    phone = json['phone'];
    gender = json['gender'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profileImage = json['profile_image'];
    verified = json['verified'];
    verificationCodes = json['verification_codes'];
    dateOfBirth = json['date_of_birth'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['phone'] = phone;
    data['gender'] = gender;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile_image'] = profileImage;
    data['verified'] = verified;
    data['verification_codes'] = verificationCodes;
    data['date_of_birth'] = dateOfBirth;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}