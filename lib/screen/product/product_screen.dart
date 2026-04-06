import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/provider/product_provider.dart';
import 'package:test_responsive/screen/product/product_form.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      context.read<ProductProvider>().fetchProduct(refresh: true);
    }
  }

  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.khmer()),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _confirmDelete(ProductModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'លុបផលិតផល',
          style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'តើអ្នកប្រាកដទេថាចង់លុប ${product.nameKm.isNotEmpty ? product.nameKm : product.nameEn}?',
          style: GoogleFonts.khmer(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('បោះបង់', style: GoogleFonts.khmer()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text('លុប', style: GoogleFonts.khmer(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<ProductProvider>();
    final success = await provider.deleteProduct(product.id);
    if (!mounted) return;

    _showSnackBar(
      success
          ? 'លុបផលិតផលបានដោយជោគជ័យ'
          : (provider.errorMessage ?? 'មានបញ្ហា'),
      success: success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ផលិតផល',
          style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCreateButton(),
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductForm()),
        );
        if (mounted) {
          context.read<ProductProvider>().fetchProduct(refresh: true);
        }
      },
      icon: Icon(Icons.add, color: theme.colorScheme.onSurface, size: 25),
      label: Text(
        'បង្កើតផលិតផលថ្មី',
        style: GoogleFonts.khmer(
          fontSize: 15,
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        context.read<ProductProvider>().search(value);
      },
      decoration: InputDecoration(
        hintText: 'ស្វែងរកផលិតផល...',
        hintStyle: GoogleFonts.khmer(fontSize: 13),
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_outlined, color: Colors.blueAccent, size: 40),
                const SizedBox(height: 10),
                Text(
                  'ស្វែងរកផលិតផលមិនឃើញ',
                  style: GoogleFonts.khmer(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200 &&
                provider.hasMore &&
                !provider.isLoading) {
              provider.fetchProduct();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: provider.products.length + (provider.hasMore ? 1 : 0),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index >= provider.products.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final product = provider.products[index];
              return _buildProductCard(product);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nameEn,
                    style: GoogleFonts.khmer(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.nameKm.isNotEmpty)
                    Text(
                      product.nameKm,
                      style: GoogleFonts.khmer(fontSize: 12),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${product.sku}  |  តម្លៃ: ${product.price.toStringAsFixed(0)} ៛',
                    style: GoogleFonts.khmer(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (product.categoryNameKm != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.categoryNameKm!,
                            style: GoogleFonts.khmer(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: product.active
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.active ? 'សកម្ម' : 'អសកម្ម',
                          style: GoogleFonts.khmer(
                            fontSize: 10,
                            color: product.active ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ស្តុក: ${product.stock.toStringAsFixed(0)}',
                        style: GoogleFonts.khmer(
                          fontSize: 11,
                          color: product.lowStock ? Colors.orange : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductForm(product: product),
                      ),
                    );
                    if (mounted) {
                      context.read<ProductProvider>().fetchProduct(refresh: true);
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(product),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
