import 'package:flutter/material.dart';
import 'package:ombapos/helpers/dao/item_dao.dart';
import 'package:ombapos/models/item_model.dart';

class ItemProvider with ChangeNotifier {
  final ItemDao _dao = ItemDao();
  List<Item> _items = [];
  final Map<int, List<Variant>> _variantsCache = {};

  List<Item> get items => _items;

  Future<void> loadItems() async {
    _items = await _dao.getAllItems();
    // Prefetch variants for all items
    for (final item in _items) {
      _variantsCache[item.id!] = await _dao.getVariantsByItemId(item.id!);
    }
    notifyListeners();
  }

  List<Variant> getVariantsSync(int itemId) {
    return _variantsCache[itemId] ?? [];
  }

  Future<void> addItemWithVariants(Item item, List<Variant> variants) async {
    final itemId = await _dao.insertItem(item);
    for (final variant in variants) {
      await _dao.insertVariant(
        Variant(
          itemId: itemId,
          name: variant.name,
          price: variant.price,
          sku: variant.sku,
        ),
      );
    }
    await loadItems();
  }

  Future<void> deleteItem(int id) async {
    await _dao.deleteItem(id);
    await loadItems();
  }
}
