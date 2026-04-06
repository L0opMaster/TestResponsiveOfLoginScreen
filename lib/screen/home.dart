import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/provider/auth_provider.dart';
import 'package:test_responsive/provider/theme_provider.dart';
import 'package:test_responsive/screen/category/category_screen.dart';
import 'package:test_responsive/screen/invoice/invoice_history_screen.dart';
import 'package:test_responsive/screen/order/order_screen.dart';
import 'package:test_responsive/screen/packaging/packging_screen.dart';
import 'package:test_responsive/screen/product/product_screen.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/sale_service.dart';
import 'package:test_responsive/util/base_url.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOrderHover = false;
  bool isPackagingHover = false;
  bool isInvoiceHover = false;
  bool isCategoryHover = false;
  bool isProductHover = false;

  final SaleService _saleService = SaleService(
    apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
  );

  int _totalOrders = 0;
  int _completedOrders = 0;
  int _totalInvoices = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOverview();
    });
  }

  Future<void> _fetchOverview() async {
    try {
      final token = await StorageService.getToken();
      final results = await Future.wait([
        _saleService.listSales(token: token, status: 'PACKAGING'),
        _saleService.listSales(token: token, status: 'PREPARING'),
        _saleService.listSales(token: token, status: 'PAID'),
      ]);
      if (!mounted) return;
      setState(() {
        _totalOrders = results[0].length + results[1].length + results[2].length;
        _completedOrders = results[2].length;
        _totalInvoices = results[2].length;
      });
    } catch (e) {
      debugPrint('Failed to fetch overview: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _topContent(),
          Expanded(child: _bodyContent()),
        ],
      ),
    );
  }

  // Top Content
  Widget _topContent() {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'សូមស្វាគមន៍ការត្រឡប់មកវិញ',
                  style: GoogleFonts.khmer(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text('Kaknnea POS', style: TextStyle(fontSize: 12)),
              ],
            ),

            Row(
              children: [
                IconButton(
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                ),
                const SizedBox(width: 10),
                IconButton(
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.logout, size: 20, color: Colors.red),
                  onPressed: () async {
                    await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).logOut();

                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Body Content
  Widget _bodyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          const SizedBox(height: 20),

          Text(
            'ម៉ឺនុយមេ',
            style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _featureOrderAndPackaging(),

          const SizedBox(height: 20),

          _featureInvoice(),

          const SizedBox(height: 30),

          _featureCategory(),

          const SizedBox(height: 30),

          _featureProduct(),

          const SizedBox(height: 30),

          _featureOverview(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // FeatureOrderAndPackaging
  Widget _featureOrderAndPackaging() {
    return Row(
      children: [
        Expanded(child: _featureOrder()),
        const SizedBox(width: 20),
        Expanded(child: _featurePackaging()),
      ],
    );
  }

  // Feature Order
  Widget _featureOrder() {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isOrderHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          isOrderHover = false;
        });
      },
      child: InkWell(
        onHover: (value) => true,
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderScreen()),
          );
          _fetchOverview();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: _cardDecoration(isHover: isOrderHover),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                _circleIcon(
                  Icons.shopping_cart_outlined,
                  Colors.blue,
                  size: 80,
                  iconSize: 40,
                ),

                const SizedBox(height: 15),

                Text(
                  'ការបញ្ជាទិញ',
                  style: GoogleFonts.khmer(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'បង្កើតការបញ្ជាទិញថ្មី',
                  style: GoogleFonts.khmer(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Feature Packaging
  Widget _featurePackaging() {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isPackagingHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          isPackagingHover = false;
        });
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackgingScreen()),
          );
          _fetchOverview();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: _cardDecoration(isHover: isPackagingHover),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                _circleIcon(
                  Icons.inventory_2_outlined,
                  Colors.green,
                  size: 80,
                  iconSize: 40,
                ),

                const SizedBox(height: 15),

                Text(
                  'ការវេចខ្ចប់',
                  style: GoogleFonts.khmer(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'ដំណើរការបញ្ជាទិញ',
                  style: GoogleFonts.khmer(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // feature Category
  Widget _featureCategory() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isCategoryHover = true;
        });
      },
      onExit: (event) => setState(() {
        isCategoryHover = false;
      }),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryScreen()),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: _cardDecoration(isHover: isCategoryHover),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              children: [
                _circleIcon(Icons.category, Colors.cyanAccent),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ប្រភេទនៃទំនិញ',
                      style: GoogleFonts.khmer(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //const SizedBox(height: 15,),
                    Text(
                      'បង្តើតប្រភេទមុខទំនិញថ្មី',
                      style: GoogleFonts.khmer(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // feature product
  Widget _featureProduct() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isProductHover = true;
        });
      },
      onExit: (event) => setState(() {
        isProductHover = false;
      }),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen()),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: _cardDecoration(isHover: isProductHover),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              children: [
                _circleIcon(Icons.add_box, Colors.blue),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ទំនិញ ឬផលិតផល',
                      style: GoogleFonts.khmer(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //const SizedBox(height: 15,),
                    Text(
                      'បង្តើតប្រភេទមុខទំនិញថ្មី',
                      style: GoogleFonts.khmer(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FeatureOverview
  Widget _featureOverview() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ទិដ្ឋភាពទូទៅថ្ងៃនេះ',
              style: GoogleFonts.khmer(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _overviewItem('$_totalOrders', 'សរុបការបញ្ជាទិញ', Colors.blue),
                _overviewItem('$_completedOrders', 'បញ្ចប់', Colors.green),
                _overviewItem('$_totalInvoices', 'វិក្កយបត្រ', Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewItem(String number, String title, Color color) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.khmer(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: GoogleFonts.khmer(fontSize: 12)),
      ],
    );
  }

  // feature Invoice
  Widget _featureInvoice() {
    return MouseRegion(
      onEnter: (event) => setState(() {
        isInvoiceHover = true;
      }),
      onExit: (event) => setState(() {
        isInvoiceHover = false;
      }),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InviceHistoryScreen()),
          );
          _fetchOverview();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: _cardDecoration(isHover: isInvoiceHover),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              children: [
                _circleIcon(Icons.inventory_outlined, Colors.purple),

                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'វិក្កយបត្រ',
                      style: GoogleFonts.khmer(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'មើលប្រវត្តិវិក្កបត្រ',
                      style: GoogleFonts.khmer(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(
    IconData icon,
    Color color, {
    double size = 70,
    double iconSize = 30,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }

  BoxDecoration _cardDecoration({bool isHover = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isHover
          ? (isDark ? const Color(0xFF2A3A2A) : const Color(0xFFDAFADB))
          : theme.colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: 0.15),
          offset: const Offset(0, 1),
          blurRadius: 7,
          spreadRadius: -6,
        ),
      ],
    );
  }
}
