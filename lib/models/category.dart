class Category {
  int? id;
  String? name;
  String? image;
  String? color;
  String? description;
  String? remove;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
        this.name,
        this.image,
        this.color,
        this.description,
        this.remove,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    color = json['color'];
    description = json['description'];
    remove = json['remove'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['color'] = color;
    data['description'] = description;
    data['remove'] = remove;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}