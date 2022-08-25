class Order {
  int? id;
  String? name;
  String? idservice;
  String? orderNumber;
  String? date;
  String? time;
  String? address;
  String? phone;
  String? totalPrice;
  String? color;
  String? notes;
  String? longitude;
  String? latitude;
  String? status;

  Order(
      {this.id,
      this.name,
      this.idservice,
      this.orderNumber,
      this.date,
      this.time,
      this.address,
      this.phone,
      this.totalPrice,
      this.color,
      this.notes,
      this.longitude,
      this.latitude,
      this.status});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    idservice = json['service']['id'].toString();
    orderNumber = json['order_number'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
    phone = json['phone'];
    totalPrice = json['total_price'].toString();
    color = json['color'];
    notes = json['notes'];
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['idservice'] = this.idservice;
    data['order_number'] = this.orderNumber;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['total_price'] = this.totalPrice;
    data['color'] = this.color;
    data['notes'] = this.notes;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status'] = this.status;
    return data;
  }
}
