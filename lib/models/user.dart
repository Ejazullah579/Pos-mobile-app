import 'achievments.dart';

class CurrentUser {
  String id;
  String firstName;
  String userType;
  String lastName;
  String phoneNumber;
  String dateOfBirth;
  String city;
  String homeAddress;
  String shopAddress;
  String shopName;
  String shopType;
  String email;
  String documentId = "";
  String imageFileName = "";
  String imageUrl = "";
  String country = "";
  String accountActivationDate;
  Achievments achievments;
  bool isNumberVerified;

  CurrentUser(
      {this.id,
      this.firstName,
      this.userType,
      this.lastName,
      this.phoneNumber,
      this.dateOfBirth,
      this.city,
      this.documentId,
      this.imageFileName,
      this.imageUrl,
      this.homeAddress,
      this.shopAddress,
      this.shopName,
      this.shopType,
      this.email,
      this.country,
      this.achievments,
      this.accountActivationDate,
      this.isNumberVerified});

  CurrentUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['firstName'],
        userType = data['userType'],
        lastName = data['lastName'],
        phoneNumber = data['phoneNumber'],
        dateOfBirth = data['dateOfBirth'],
        country = data['country'],
        city = data['city'],
        documentId = data['documentId'],
        imageFileName = data['imageFileName'],
        achievments = Achievments.fromJson(data['achievments']),
        imageUrl = data['imageUrl'],
        homeAddress = data['homeAddress'],
        shopAddress = data['shopAddress'],
        shopType = data['shopType'],
        shopName = data['shopName'],
        email = data['email'],
        //TODO remove null aware..
        accountActivationDate = data['accountActivationDate'] ?? "emppty",
        isNumberVerified = data['isNumberVerified'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'userType': userType,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'city': city,
      'documentId': documentId,
      'imageFileName': imageFileName,
      'imageUrl': imageUrl,
      'achievments': achievments.toJson(),
      'homeAddress': homeAddress,
      'shopAddress': shopAddress,
      'shopType': shopType,
      'shopName': shopName,
      'accountActivationDate': accountActivationDate,
      'isNumberVerified': isNumberVerified
    };
  }

  @override
  String toString() {
    return id + " " + firstName + " " + lastName + " " + city;
  }
}
