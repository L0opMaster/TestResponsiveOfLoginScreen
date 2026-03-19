import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_responsive/screen/invoice/invoice_screen.dart';

class InviceHistoryScreen extends StatelessWidget {
  const InviceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.amberAccent,
        title: Text(
          'ប្រវត្តិវិក្កយប័ត្រ',
          style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size(0, 70),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
            child: SearchBar(
              padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10)),
              leading: const Icon(Icons.search),
              hintText: 'ស្វែងរករប្រវត្តិវិក្កយប័ត្រ',
              hintStyle: WidgetStatePropertyAll(
                GoogleFonts.khmer(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: SizedBox(
              child: Column(
                children: [
                  _buildImforInvoice(),
                  SizedBox(height: 20),
                  _buildListInvoice(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImforInvoice() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ចំនួនប្រតិបត្តិការ',
                      style: GoogleFonts.khmer(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: const Color(0xFF89C9FD),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '2',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Icon(Icons.book_rounded, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(thickness: 1, height: 1, color: Colors.white),
            SizedBox(height: 20),

            Text(
              'ប្រាក់ចំណូលសរុប',
              style: GoogleFonts.khmer(fontSize: 14, color: Colors.white60),
            ),
            SizedBox(height: 10),
            Text(
              '\$389.96',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListInvoice() {
    return SizedBox(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.book_rounded,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              'INV-139630',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$109.98',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text('Order: ORD-149349'),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Jonn Sey',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text('+855 123456789'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mar 18, 2026', style: TextStyle(fontSize: 12)),
                        Text('01:08 PM', style: TextStyle(fontSize: 12)),
                        Text('2 items', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                              maximumSize: Size.fromHeight(60),
                              backgroundColor: Colors.blue.shade800,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceScreen(),
                                ),
                              );
                            },
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Text(
                                'View',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            icon: Icon(Icons.book_rounded, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 15),
                        Icon(Icons.print_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
