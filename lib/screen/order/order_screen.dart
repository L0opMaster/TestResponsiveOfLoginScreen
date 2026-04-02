import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/provider/category_provider.dart';
import 'package:test_responsive/provider/product_provider.dart';
import 'package:test_responsive/screen/order/cart_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 5.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
          child: const Icon(Icons.shopping_cart),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //  FIXED STRUCTURE
      body: Column(
        children: [
          _topContentOfOrder(context),
          Expanded(
            child: _buildContentBody(),
          ),
        ],
      ),
    );
  }

  // 🔹 TOP UI
  Widget _topContentOfOrder(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 1),
            blurRadius: 7,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  'ផលិតផល​ និងទំនិញ',
                  style: GoogleFonts.khmer(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SearchBar(
              padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10)),
              leading: const Icon(Icons.search),
              hintText: 'ស្វែងរកទំនិញ',
              hintStyle: WidgetStatePropertyAll(
                GoogleFonts.khmer(fontSize: 12),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                context.read<ProductProvider>().search(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 BODY
  Widget _buildContentBody() {
    return Column(
      children: [
        //CATEGORY LIST (FIXED HEIGHT)
        Consumer<CategoryProvider>(
          builder: (context, provider, child) {
            // if empty → DON'T build SizedBox
            if (provider.categories.isEmpty) {
              return const SizedBox(); // nothing
            }

            // loading
            if (provider.isLoading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // only build SizedBox when data exists
            return SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.categories.length,
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(category.nameKm),
                      selected: provider.selectedCategoryId == category.id,
                      onSelected: (_) {
                        provider.setSelectedCategory(category.id);

                        context.read<ProductProvider>().fetchProduct(
                          refresh: true,
                          categoryId: category.id == 0 ? null : category.id,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),

        //PRODUCT GRID
        Expanded(
          child: Consumer<ProductProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!provider.isLoading && provider.products.isEmpty) {
                return Center(
                  child: Text(
                    'រកមិនឃើញ',
                    style: GoogleFonts.khmer(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 100 &&
                      !provider.isLoading &&
                      provider.hasMore) {
                    provider.fetchProduct();
                  }
                  return false;
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.60,
                  ),
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    return _buildCardProduct(product);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 🔹 PRODUCT CARD
  Widget _buildCardProduct(ProductModel product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                product.imageUrl ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey.shade100,
                      child: Icon(Icons.image_not_supported_rounded),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nameKm,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.khmer(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${product.price.toStringAsFixed(0)}៛',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('បន្ថែម'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
