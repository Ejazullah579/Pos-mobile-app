class Subscription {
  String endDate;
  String startDate;
  String userId;

  Subscription({this.userId, this.startDate, this.endDate});

  Subscription.fromData(Map<String, dynamic> data)
      : userId = data['userId'],
        startDate = data['startDate'],
        endDate = data['endDate'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
