class SponsorAdd {
  String type;
  String title;
  String description;
  double productPrice;
  String productPicUrl;
  String expiryDate;
  String siteUrl;
  String videoUrl;

  SponsorAdd(
      {this.title,
      this.description,
      this.type,
      this.productPrice,
      this.siteUrl,
      this.videoUrl,
      this.productPicUrl,
      this.expiryDate});

  SponsorAdd.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        description = data['description'],
        type = data['type'],
        expiryDate = data['expiryDate'],
        productPrice = data['productPrice'] ?? 0,
        siteUrl = data['siteUrl'] ?? "",
        videoUrl = data['videoUrl'] ?? "",
        productPicUrl = data['productPicUrl'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'productPrice': productPrice,
      'siteUrl': siteUrl,
      'expiryDate': expiryDate,
      'videoUrl': videoUrl,
      'productPicUrl': productPicUrl
    };
  }
}
