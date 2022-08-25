class NGeniusPaymentModel {
  String? id;
  String? links;

  NGeniusPaymentModel({this.id, this.links});

  factory NGeniusPaymentModel.formJSON(Map<String, dynamic> json) {
    return NGeniusPaymentModel(id: json['_id'], links: json['_links']['payment']['href']);
  }
}
