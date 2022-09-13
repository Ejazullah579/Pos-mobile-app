class Api {
  List list = [
    {'id': "1", "pass": "samosa"},
    {"id": "2", "pass": "ejazullah"},
    {"id": "6", "pass": "ejazullah0000"}
  ];
  Future getUserProfile(userId, pass) async {
    var result;
    try {
      result = list.firstWhere(
          (element) => element['id'] == userId && element['pass'] == pass);
    } catch (e) {
      result = null;
    }

    print(result);
    return result;
  }
}
