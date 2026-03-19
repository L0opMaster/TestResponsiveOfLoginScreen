import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_responsive/screen/invoice/invice_history_screen.dart';
import 'package:test_responsive/screen/order/order_screen.dart';
import 'package:test_responsive/screen/packaging/packging_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOrderHover = false;
  bool isPackagingHover = false;
  bool isInvoiceHover = false;
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
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

            IconButton(
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.logout, size: 20),
              onPressed: () {},
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderScreen()),
          );
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackgingScreen()),
          );
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
                _overviewItem('0', 'សរុបការបញ្ជាទិញ', Colors.blue),
                _overviewItem('0', 'បញ្ចប់', Colors.green),
                _overviewItem('0', 'វិក្កយបត្រ', Colors.purple),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InviceHistoryScreen()),
          );
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
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }

  BoxDecoration _cardDecoration({bool isHover = false}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isHover ? const Color(0xFFDAFADB) : Colors.white,
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF4b4b4b).withOpacity(0.2),
          offset: const Offset(0, 1),
          blurRadius: 7,
          spreadRadius: -6,
        ),
      ],
    );
  }
}
