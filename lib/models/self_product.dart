class SelfProduct {
  String userId;
  String productId;
  String productName;
  final double purchasePrice;
  final double salePrice;
  final String image;

  SelfProduct(
      {this.purchasePrice,
      this.salePrice,
      this.productName,
      this.userId,
      this.productId,
      this.image});

  SelfProduct.noValues({String productId, userId})
      : productId = productId,
        productName = "Enter Name",
        purchasePrice = 0,
        salePrice = 0,
        userId = userId,
        image = "";

  SelfProduct.fromJson(Map<String, dynamic> data)
      : productName = data['productName'],
        userId = data['userId'],
        productId = data['productId'],
        purchasePrice = data['purchasePrice'],
        salePrice = data['salePrice'],
        //TODO remove null aware.
        image = data['image'] ?? "empty";

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'image': image
    };
  }
}
