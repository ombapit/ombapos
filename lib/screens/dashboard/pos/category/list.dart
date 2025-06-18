import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/utils/database_helper.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final data = await _dbHelper.getAllKategori();
    setState(() {
      _categories = data;
    });
  }

  Future<void> _addOrEditCategory({Map<String, dynamic>? category}) async {
    final TextEditingController controller = TextEditingController(
      text: category != null ? category['name'] : '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              if (category == null) {
                await _dbHelper.insertKategori(controller.text.trim());
              } else {
                await _dbHelper.editCategory(
                  category['id'],
                  controller.text.trim(),
                );
              }
              Navigator.pop(context);
              _fetchCategories();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(int id) async {
    await _dbHelper.deleteKategori(id);
    _fetchCategories();
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _deleteCategory(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supaya leading bisa di-custom
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(true),
            ),
            const Text('Manage Categories'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditCategory(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(cat['nama'].substring(0, 2).toUpperCase()),
            ),
            title: Text(cat['nama']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _addOrEditCategory(category: cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(cat['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
