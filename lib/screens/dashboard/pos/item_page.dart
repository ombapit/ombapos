import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ombapos/models/item_model.dart';
import 'package:ombapos/providers/category_provider.dart';
import 'package:ombapos/providers/item_provider.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _skuController = TextEditingController();
  final _variantNameController = TextEditingController();

  String? _selectedCategoryId;
  File? _imageFile;
  List<Variant> _variants = [];

  Future<void> _pickAndCropImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            lockAspectRatio: true,
          ),
          IOSUiSettings(aspectRatioLockEnabled: true),
        ],
      );
      if (cropped != null) {
        setState(() => _imageFile = File(cropped.path));
      }
    }
  }

  void _addVariant() {
    if (_variants.length >= 1 &&
        (_priceController.text.trim().isEmpty ||
            _skuController.text.trim().isEmpty))
      return;

    setState(() {
      _variants.add(
        Variant(
          name: _variantNameController.text.trim(),
          price: int.tryParse(_priceController.text.trim()) ?? 0,
          sku: _skuController.text.trim(),
        ),
      );
      _variantNameController.clear();
    });
  }

  Future<void> _saveItem() async {
    if (_nameController.text.trim().isEmpty ||
        _selectedCategoryId == null ||
        _variants.isEmpty)
      return;

    final item = Item(
      name: _nameController.text.trim(),
      categoryId: int.parse(_selectedCategoryId!),
      imagePath: _imageFile?.path,
    );

    final itemProvider = context.read<ItemProvider>();
    await itemProvider.addItemWithVariants(item, _variants);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Item"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveItem),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAndCropImage,
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.add_a_photo, size: 40),
                    ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat.id.toString(),
                      child: Text(cat.name),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategoryId = val),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skuController,
              decoration: const InputDecoration(labelText: 'SKU'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _variantNameController,
              decoration: const InputDecoration(labelText: 'Variant Name'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addVariant,
              child: const Text('Add Variant'),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _variants.length,
              itemBuilder: (context, index) {
                final variant = _variants[index];
                return ListTile(
                  title: Text(variant.name),
                  subtitle: Text(
                    "Price: ${variant.price} | SKU: ${variant.sku}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _variants.removeAt(index)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
