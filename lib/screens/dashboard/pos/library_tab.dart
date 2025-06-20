import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/providers/category_provider.dart';
import 'package:ombapos/providers/item_provider.dart';
import 'package:ombapos/models/item_model.dart';
import 'package:provider/provider.dart';

class LibraryTab extends StatefulWidget {
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onSubTitleChanged;

  const LibraryTab({super.key, this.onTitleChanged, this.onSubTitleChanged});

  @override
  State<LibraryTab> createState() => LibraryTabState();
}

class LibraryTabState extends State<LibraryTab> {
  bool _isLoading = true;
  bool isEditMode = false;
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<CategoryProvider>().fetchCategories();
    await context.read<ItemProvider>().loadItems();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void resetView() {
    setState(() {
      selectedCategory = null;
      isEditMode = false;
    });
  }

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;
    final items = context.watch<ItemProvider>().items;

    final isProductView = selectedCategory != null;
    final filteredItems = items
        .where((item) => item.categoryId == selectedCategory)
        .toList();

    return Column(
      children: [
        _buildHeader(isProductView),
        if (isEditMode && !isProductView) _buildEditButtons(context),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : isProductView
              ? _buildProductList(filteredItems)
              : _buildCategoryList(categories),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isProductView) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: isEditMode
                ? Text(
                    isProductView ? "List Menu" : 'Manage Data',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          if (!isProductView)
            isEditMode
                ? TextButton(
                    onPressed: () => setState(() => isEditMode = false),
                    child: const Text('DONE'),
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    iconSize: 28,
                    onPressed: () => setState(() => isEditMode = true),
                  ),
        ],
      ),
    );
  }

  Widget _buildEditButtons(BuildContext context) {
    return Column(
      children: [
        _buildFlatButton(context, 'CREATE ITEM', '/pos/item'),
        _buildFlatButton(context, 'MANAGE CATEGORIES', '/pos/category'),
      ],
    );
  }

  Widget _buildFlatButton(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => context.go(route),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildCategoryList(List categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final prefix = cat.name.length >= 2
            ? cat.name.substring(0, 2).toUpperCase()
            : cat.name.toUpperCase();

        return GestureDetector(
          onTap: () {
            setState(() => selectedCategory = cat.id);
            widget.onTitleChanged?.call(cat.name);
            widget.onSubTitleChanged?.call(
              context
                  .read<ItemProvider>()
                  .items
                  .where((i) => i.categoryId == cat.id)
                  .length
                  .toString(),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    prefix,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(cat.name, style: const TextStyle(fontSize: 16)),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList(List<Item> filteredItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final variants = context.read<ItemProvider>().getVariantsSync(item.id!);
        final firstPrice = variants.isNotEmpty ? variants.first.price : 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: item.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(
                      File(item.imagePath!), // path lokal
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.fastfood, size: 40),
            title: Text(item.name),
            subtitle: Text('Tap to select'),
            trailing: Text(
              variants.length == 1
                  ? formatCurrency.format(firstPrice)
                  : '${variants.length} Price',
            ),
            onTap: () async {
              if (variants.length == 1) {
                print('Tambah ke keranjang: ${variants.first.price}');
              } else {
                context.push('/pos/item/${item.id}');
              }
            },
          ),
        );
      },
    );
  }
}
