class Utils {
  static List<T> map<T>(List<dynamic> collection, T Function(int index, dynamic element) callback) {
    int index = 0;
    List<T> returnList = [];

    for (var element in collection) {
      returnList.add(callback(index, element));
      index++;
    }

    return returnList;
  }
}
