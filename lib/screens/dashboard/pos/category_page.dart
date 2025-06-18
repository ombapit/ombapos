import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/models/category_model.dart';
import 'package:ombapos/providers/category_provider.dart';
import 'package:ombapos/widgets/appbar.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoryProvider>().fetchCategories());
  }

  Future<void> _addOrEditCategory(
    BuildContext context, {
    Category? category,
  }) async {
    final controller = TextEditingController(text: category?.name ?? '');
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
              final provider = context.read<CategoryProvider>();
              final text = controller.text.trim();
              if (text.isEmpty) return;
              if (category == null) {
                await provider.addCategory(text);
              } else {
                await provider.updateCategory(
                  Category(id: category.id, name: text),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await context.read<CategoryProvider>().deleteCategory(id);
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
    final provider = context.watch<CategoryProvider>();
    final categories = provider.categories;

    return Scaffold(
      appBar: CustAppBar(
        title: "Manage Categories",
        onActionPressed: () => _addOrEditCategory(context),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final prefix = cat.name.length >= 2
              ? cat.name.substring(0, 2).toUpperCase()
              : cat.name.toUpperCase();
          return ListTile(
            leading: CircleAvatar(child: Text(prefix)),
            title: Text(cat.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _addOrEditCategory(context, category: cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, cat.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
