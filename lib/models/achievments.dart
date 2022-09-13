class Achievments {
  int totalSales;
  int totalProductsSoled;
  int totalDaysAppUsed;

  Achievments(
      {this.totalDaysAppUsed, this.totalSales, this.totalProductsSoled});

  Achievments.fromJson(Map<String, dynamic> data)
      : totalDaysAppUsed = data['totalDaysAppUsed'],
        totalSales = data['totalSales'],
        totalProductsSoled = data['totalProductsSoled'];

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalProductsSoled': totalProductsSoled,
      'totalDaysAppUsed': totalDaysAppUsed,
    };
  }
}
