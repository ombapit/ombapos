import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/models/item_model.dart';
import 'package:ombapos/providers/item_provider.dart';
import 'package:ombapos/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ItemVariantPage extends StatefulWidget {
  final int itemId;

  const ItemVariantPage({super.key, required this.itemId});

  @override
  State<ItemVariantPage> createState() => _ItemVariantPageState();
}

class _ItemVariantPageState extends State<ItemVariantPage> {
  List<Variant> _variants = [];
  bool _isLoading = true;

  late String itemName;
  late Item item;

  @override
  void initState() {
    super.initState();

    item = context.read<ItemProvider>().items.firstWhere(
      (e) => e.id == widget.itemId,
    );

    _loadVariants();
  }

  void _loadVariants() {
    final variants = context.read<ItemProvider>().getVariantsSync(
      widget.itemId,
    );
    if (mounted) {
      setState(() {
        _variants = variants;
        itemName = '${item.name} - ${variants.first.name}';
        _isLoading = false;
      });
    }
  }

  String formatPrice(num price) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(title: itemName),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _variants.length,
              itemBuilder: (context, index) {
                final variant = _variants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(variant.name),
                    subtitle: Text('Rp ${formatPrice(variant.price)}'),
                    onTap: () {
                      // Tambahkan ke keranjang, atau navigasi sesuai kebutuhan
                      print('Tambah ke keranjang: ${variant.name}');
                      setState(() {
                        itemName = '${item.name} - ${variant.name}';
                      });
                      // context.pop(); // Atau navigasi ke halaman berikutnya
                    },
                  ),
                );
              },
            ),
    );
  }
}
