class Photo {
  final int id;
  final String description;
  final String date;
  final String path;

  Photo(
      {required this.description,
      required this.date,
      required this.path,
      this.id = 0});

  // Use to insert row in table
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["date"] = date;
    map["description"] = description;
    map["path"] = path;
    return map;
  }

  // Convert row to object
  factory Photo.fromMap(Map<String, dynamic> item) => Photo(
      id: item['id'],
      description: item['description'],
      date: item['date'],
      path: item['path']);
}
