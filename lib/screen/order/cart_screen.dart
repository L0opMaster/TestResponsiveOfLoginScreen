import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/cart_model.dart';
import 'package:test_responsive/provider/cart_provider.dart';
import 'package:test_responsive/provider/customer_provider.dart';
import 'package:test_responsive/screen/order/customer_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CustomerProvider>().fetchCustomers(refresh: true);
      });
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

  // CHANGED: New method — opens a dialog to edit the unit price of a cart item.
  // After user enters a new price, calls updateQuantity() with the same quantity
  // but the new unitPrice. Backend recalculates totalPrice and cart total.
  // Use case: product is 20000៛ but seller wants to sell at 18000៛ for this customer.
  Future<void> _editPrice(CartItemModel item, CartProvider cartProvider) async {
    final controller = TextEditingController(
      text: item.unitPrice.toStringAsFixed(0),
    );

    final newPrice = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('កែតម្លៃ', style: GoogleFonts.khmer(fontSize: 16)),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'តម្លៃ (៛)',
              labelStyle: GoogleFonts.khmer(),
              border: const OutlineInputBorder(),
              suffixText: '៛',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('បោះបង់', style: GoogleFonts.khmer()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                final price = double.tryParse(controller.text);
                if (price != null && price > 0) {
                  Navigator.pop(context, price);
                }
              },
              child: Text(
                'រក្សាទុក',
                style: GoogleFonts.khmer(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (newPrice == null || !mounted) return;

    final success = await cartProvider.updateQuantity(
      itemId: item.id,
      quantity: item.quantity,
      unitPrice: newPrice,
    );
    if (!mounted) return;
    _showSnackBar(success ? 'បានកែតម្លៃ' : 'មានកំហុស', success: success);
  }

  Future<void> _removeItem(CartItemModel item) async {
    final success = await context.read<CartProvider>().removeItem(
      itemId: item.id,
    );
    if (!mounted) return;
    _showSnackBar(
      success ? 'បានលុបទំនិញ' : 'មានកំហុសក្នុងការលុប',
      success: success,
    );
  }

  Future<void> _checkout() async {
    final cartProvider = context.read<CartProvider>();

    final success = await cartProvider.checkout();
    if (!mounted) return;

    if (success) {
      _showSnackBar('បានបញ្ជូនដោយជោគជ័យ');
      Navigator.pop(context);
    } else {
      _showSnackBar(cartProvider.errorMessage ?? 'មានកំហុស', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopContent(context),
            _buildListProduct(),
            _buildSubmitSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                'រទេះទំនិញ',
                style: GoogleFonts.khmer(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, cart, _) {
                  if (cart.itemCount == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // Row(
          //   children: [
          //     // DropdownButtonHideUnderline(
          //     //   child: Consumer<CustomerProvider>(
          //     //     builder: (context, provider, child) {
          //     //       if (provider.customers.isEmpty) {
          //     //         return const Text("No customers");
          //     //       }

          //     //       return DropdownButton2(
          //     //         isDense: true,
          //     //         style: GoogleFonts.khmer(
          //     //           fontSize: 14,
          //     //           fontWeight: FontWeight.bold,
          //     //         ),
          //     //         dropdownStyleData: const DropdownStyleData(maxHeight: 200),
          //     //         buttonStyleData: ButtonStyleData(
          //     //           height: 40,
          //     //           decoration: BoxDecoration(
          //     //             borderRadius: BorderRadius.circular(10),
          //     //             border: Border.all(width: 1, color: Colors.black87),
          //     //           ),
          //     //         ),
          //     //         valueListenable: provider.selectedCustomer,
          //     //         hint: const Text("Select Customer"),
          //     //         items: provider.customers.map((customer) {
          //     //           return DropdownItem(
          //     //             value: customer.id,
          //     //             child: Text(customer.nameKm ?? customer.nameEn ?? customer.code),
          //     //           );
          //     //         }).toList(),
          //     //         onChanged: (value) {
          //     //           provider.setSelectedCustomer(value as int);
          //     //         },
          //     //       );
          //     //     },
          //     //   ),
          //     // ),
          //     // const SizedBox(width: 10),
          //     // IconButton(
          //     //   onPressed: () {
          //     //     Navigator.push(
          //     //       context,
          //     //       MaterialPageRoute(builder: (context) => const CustomerScreen()),
          //     //     );
          //     //   },
          //     //   icon: const Icon(Icons.add),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildListProduct() {
    return Expanded(
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'រទេះទំនិញទទេ',
                    style: GoogleFonts.khmer(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return _buildCartItem(item, cartProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: Colors.blue.shade200,
                  size: 32,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productNameKm.isNotEmpty
                          ? item.productNameKm
                          : item.productNameEn,
                      style: GoogleFonts.khmer(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // CHANGED: Price is now tappable — tap to open edit price dialog.
                    // Shows a small edit icon next to the price to hint it's editable.
                    GestureDetector(
                      onTap: () => _editPrice(item, cartProvider),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${item.unitPrice.toStringAsFixed(0)} ៛',
                            style: GoogleFonts.khmer(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.blue.shade300,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: item.quantity > 1
                              ? () => cartProvider.updateQuantity(
                                  itemId: item.id,
                                  quantity: item.quantity - 1,
                                )
                              : null,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: item.quantity > 1
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 18,
                              color: item.quantity > 1
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => cartProvider.updateQuantity(
                            itemId: item.id,
                            quantity: item.quantity + 1,
                          ),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'សរុបរង: ${item.totalPrice.toStringAsFixed(0)} ៛',
                      style: GoogleFonts.khmer(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _removeItem(item),
                icon: const Icon(
                  Icons.restore_from_trash_rounded,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10.0,
        bottom: 15,
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildPrice(), const SizedBox(height: 10), _submitButton()],
      ),
    );
  }

  Widget _buildPrice() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final total = cartProvider.totalAmount;
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: theme.colorScheme.surface,
            border: Border.all(width: 1, color: theme.dividerColor),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('សរុបរង', style: GoogleFonts.khmer(fontSize: 15)),
                    Text(
                      '${total.toStringAsFixed(0)} ៛',
                      style: GoogleFonts.khmer(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 1),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'សរុបរួម',
                      style: GoogleFonts.khmer(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${total.toStringAsFixed(0)} ៛',
                      style: GoogleFonts.khmer(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: cartProvider.isSubmitting || cartProvider.isEmpty
              ? null
              : _checkout,
          child: cartProvider.isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'បញ្ជូន',
                  style: GoogleFonts.khmer(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }
}
