class Item {
  final int? id;
  final String name;
  final int categoryId;
  final String? imagePath;

  Item({this.id, required this.name, required this.categoryId, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'image_path': imagePath,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      imagePath: map['image_path'],
    );
  }
}

class Variant {
  final int? id;
  final int? itemId;
  final String name;
  final int price;
  final String sku;

  Variant({
    this.id,
    this.itemId,
    required this.name,
    required this.price,
    required this.sku,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_id': itemId,
      'name': name,
      'price': price,
      'sku': sku,
    };
  }

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      id: map['id'],
      itemId: map['item_id'],
      name: map['name'],
      price: map['price'],
      sku: map['sku'],
    );
  }
}
