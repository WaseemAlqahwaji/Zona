class Services {
  int? id;
  String? image;
  String? name;
  String? description;
  int? price;
  String? totalPrice;
  String? isColor;
  String? idcategory;
  String? idprovider;
  String? address;
  int? rate;
  String? status;
  String? remove;
  String? createdAt;
  String? updatedAt;

  Services(
      {this.id,
      this.image,
      this.name,
      this.description,
      this.price,
      this.totalPrice,
      this.isColor,
      this.idcategory,
      this.idprovider,
      this.address,
      this.rate,
      this.status,
      this.remove,
      this.createdAt,
      this.updatedAt});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    totalPrice = json['total_price'];
    isColor = json['is_color'];
    idcategory = json['idcategory'];
    idprovider = json['idprovider'];
    address = json['address'];
    rate = json['rate'];
    status = json['status'];
    remove = json['remove'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['total_price'] = this.totalPrice;
    data['is_color'] = this.isColor;
    data['idcategory'] = this.idcategory;
    data['idprovider'] = this.idprovider;
    data['address'] = this.address;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['remove'] = this.remove;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
