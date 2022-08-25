class Provider {
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
  String? remove;
  int? idcategory;
  String? description;
  String? location;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;

  Provider(
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
      this.remove,
      this.idcategory,
      this.description,
      this.location,
      this.dateOfBirth,
      this.createdAt,
      this.updatedAt});

  Provider.fromJson(Map<String, dynamic> json) {
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
    remove = json['remove'];
    idcategory = json['idcategory'];
    description = json['description'];
    location = json['location'];
    dateOfBirth = json['date_of_birth'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_image'] = this.profileImage;
    data['verified'] = this.verified;
    data['verification_codes'] = this.verificationCodes;
    data['remove'] = this.remove;
    data['idcategory'] = this.idcategory;
    data['description'] = this.description;
    data['location'] = this.location;
    data['date_of_birth'] = this.dateOfBirth;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
