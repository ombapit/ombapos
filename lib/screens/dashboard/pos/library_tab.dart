import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/helpers/dao/category_dao.dart';
import 'package:ombapos/models/category_model.dart';
import 'package:ombapos/providers/category_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await context.read<CategoryProvider>().fetchCategories();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  bool isEditMode = false;
  String? selectedCategory;

  final Map<String, List<Map<String, dynamic>>> productsByCategory = {
    'Bakso': [
      {'name': 'Bakso Biasa', 'price': '10k', 'image': Icons.ramen_dining},
      {'name': 'Bakso Urat', 'price': '12k', 'image': Icons.ramen_dining},
    ],
    'Sate': [
      {'name': 'Sate Ayam', 'price': '15k', 'image': Icons.kebab_dining},
      {'name': 'Sate Kambing', 'price': '25k', 'image': Icons.kebab_dining},
    ],
    'Nasi Goreng': [
      {'name': 'Nasi Goreng Spesial', 'price': '18k', 'image': Icons.rice_bowl},
    ],
  };

  void resetView() {
    setState(() {
      selectedCategory = null;
      isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;
    final isProductView = selectedCategory != null;
    final productList = isProductView
        ? productsByCategory[selectedCategory] ?? []
        : [];

    return Column(
      children: [
        // AppBar manual
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isEditMode
                        ? Text(
                            isProductView
                                ? "List Menu"
                                : isEditMode
                                ? 'Manage Data'
                                : 'Daftar Kategori',
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!isProductView)
                isEditMode
                    ? TextButton(
                        onPressed: () {
                          setState(() => isEditMode = false);
                        },
                        child: const Text('DONE'),
                      )
                    : IconButton(
                        icon: const Icon(Icons.edit),
                        iconSize: 28,
                        onPressed: () {
                          setState(() => isEditMode = true);
                        },
                      ),
            ],
          ),
        ),

        if (isEditMode && !isProductView) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  context.go('/pos/item');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor, // ⬅️ Background pakai primary
                  foregroundColor: Colors.white, // ⬅️ Text putih
                  elevation: 0, // ⬅️ Flat (tanpa bayangan)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ), // ⬅️ Tanpa radius
                ),
                child: const Text('CREATE ITEM'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  context.go('/pos/category');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor, // ⬅️ Background pakai primary
                  foregroundColor: Colors.white, // ⬅️ Text putih
                  elevation: 0, // ⬅️ Flat (tanpa bayangan)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ), // ⬅️ Tanpa radius
                ),
                child: const Text('MANAGE CATEGORIES'),
              ),
            ),
          ),
        ],

        Expanded(
          child: isProductView
              ? ListView.builder(
                  itemCount: productList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final item = productList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(item['image'], size: 40),
                        title: Text(item['name']),
                        trailing: Text(item['price']),
                      ),
                    );
                  },
                )
              : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final prefix = cat.name.length >= 2
                        ? cat.name.substring(0, 2).toUpperCase()
                        : cat.name.toUpperCase();
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = cat.name);
                        widget.onTitleChanged?.call(cat.name);
                        widget.onSubTitleChanged?.call(
                          (productsByCategory[selectedCategory] ?? []).length
                              .toString(),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
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
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
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
                              child: Text(
                                cat.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
