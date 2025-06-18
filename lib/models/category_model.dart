class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  // Konversi dari Map (database) ke objek Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'], name: map['name']);
  }

  // Konversi dari objek Category ke Map (untuk insert/update)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
