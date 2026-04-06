import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/provider/cart_provider.dart';
import 'package:test_responsive/provider/category_provider.dart';
import 'package:test_responsive/provider/customer_provider.dart';
import 'package:test_responsive/provider/product_provider.dart';
import 'package:test_responsive/screen/order/cart_screen.dart';
import 'package:test_responsive/screen/order/customer_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductProvider>().fetchProduct();
        context.read<CategoryProvider>().fetchCategories();
        context.read<CustomerProvider>().fetchCustomers(refresh: true);
      });
    }
  }

  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.khmer()),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // CHANGED: Must select customer before adding to cart.
  // The customerId is passed to addItem() which auto-creates the backend cart
  // on the first add. If no customer selected → shows red snackbar warning.
  Future<void> _addToCart(ProductModel product) async {
    final customerId = context.read<CustomerProvider>().selectedCustomer.value;
    if (customerId == null) {
      _showSnackBar('សូមជ្រើសរើសអតិថិជនជាមុនសិន', success: false);
      return;
    }

    final success = await context.read<CartProvider>().addItem(
      productId: product.id,
      customerId: customerId,
    );
    if (!mounted) return;
    if (success) {
      _showSnackBar('បានបន្ថែម ${product.nameKm}');
    } else {
      _showSnackBar('មានកំហុសក្នុងការបន្ថែម', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 5.0),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: Badge(
                isLabelVisible: cartProvider.itemCount > 0,
                label: Text('${cartProvider.itemCount}'),
                child: const Icon(Icons.shopping_cart),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Column(
        children: [
          _topContentOfOrder(context),
          Expanded(child: _buildContentBody()),
        ],
      ),
    );
  }

  Widget _topContentOfOrder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.2),
            offset: const Offset(0, 1),
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
                const Spacer(),
                // CHANGED: Customer dropdown moved here from CartScreen.
                // User must select customer before adding items to cart.
                _buildCustomerDropdown(context),
                const SizedBox(width: 5),
                // CHANGED: Button to add new customer (navigates to CustomerScreen)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add, size: 20),
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

  // CHANGED: New widget — customer dropdown in the order screen top bar.
  // Fetched on screen load. Required before any item can be added to cart.
  Widget _buildCustomerDropdown(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.customers.isEmpty) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (provider.customers.isEmpty) {
          return Text('មិនមានអតិថិជន', style: GoogleFonts.khmer(fontSize: 12));
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton2(
            isDense: true,
            style: GoogleFonts.khmer(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            dropdownStyleData: DropdownStyleData(maxHeight: 200),
            buttonStyleData: ButtonStyleData(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: theme.dividerColor,
                ),
              ),
            ),
            valueListenable: provider.selectedCustomer,
            hint: Text('ជ្រើសអតិថិជន', style: GoogleFonts.khmer(fontSize: 12)),
            items: provider.customers.map((customer) {
              return DropdownItem(
                value: customer.id,
                child: Text(
                  customer.nameKm ?? customer.nameEn ?? customer.code,
                ),
              );
            }).toList(),
            onChanged: (value) {
              provider.setSelectedCustomer(value as int);
            },
          ),
        );
      },
    );
  }

  Widget _buildContentBody() {
    return Column(
      children: [
        Consumer<CategoryProvider>(
          builder: (context, provider, child) {
            if (provider.categories.isEmpty) {
              return const SizedBox();
            }

            if (provider.isLoading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            }

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
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                    onPressed: () => _addToCart(product),
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
