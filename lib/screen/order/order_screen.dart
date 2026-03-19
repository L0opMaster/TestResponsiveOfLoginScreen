import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_responsive/screen/order/cart_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

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
          child: Icon(Icons.shopping_cart),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [_topContentOfOrder(context), _buildContentBody()],
      ),
    );
  }

  // top content of order
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
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Text(
                  'ផលិតផល​ និងទំនិញ',
                  style: GoogleFonts.khmer(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            SearchBar(
              padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10)),
              leading: const Icon(Icons.search),
              hintText: 'ស្វែងរកទំនិញ',
              hintStyle: WidgetStatePropertyAll(
                GoogleFonts.khmer(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Content body

  Widget _buildContentBody() {
    return Expanded(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.60,
            ),
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildCardProduct();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardProduct() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Responsive image
          AspectRatio(
            aspectRatio: 1.2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                'https://img.artpal.com/933782/19-23-10-1-14-12-54m.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      'ប្រភេទផលិតផល',
                      style: GoogleFonts.khmer(fontSize: 11),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Product name
                  Text(
                    'ឈ្មោះផលិតផល',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.khmer(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Price
                  Text(
                    '១២០០០ រ',
                    style: GoogleFonts.khmer(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const Spacer(),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'បន្ថែម',
                        style: GoogleFonts.khmer(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {},
                    ),
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
