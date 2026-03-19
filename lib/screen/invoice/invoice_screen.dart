import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black87,
        elevation: 2,
        title: Text(
          'វិក្កយបត្រ',
          style: GoogleFonts.khmer(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [_buildInvoice(), _buildPrintAndShareButtom()],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoice() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildTopIntroduceInvoice(),
          _buildTopContentInvoice(),
          _buildCustomerDetails(),
          _buildItem(),
          _buildTotal(),
          _buildThanakYou(),
        ],
      ),
    );
  }

  Widget _buildTopIntroduceInvoice() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(),
        color: Colors.lightGreen.shade700,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline_outlined, color: Colors.white),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ការបញ្ជាទិញបានបញ្ចប់',
                  style: GoogleFonts.khmer(fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'វិក្កយបត្រ​ត្រូវ​បាន​បង្កើត​ដោយ​ជោគជ័យ',
                  style: GoogleFonts.khmer(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContentInvoice() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'KAKNNEA POS ORDER Packaging',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('KAKNNEA POS', style: TextStyle(fontSize: 12)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('លេខវិក្កយបត្រ', style: GoogleFonts.khmer(fontSize: 12)),
                Text(
                  'INV-ORD-149349',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('លេខការបញ្ជាទិញ', style: GoogleFonts.khmer(fontSize: 12)),
                Text(
                  'ORD-149349',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('កាលបរិច្ឆេត', style: GoogleFonts.khmer(fontSize: 12)),
                Text(
                  'March 18, 2026',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: Border(
          top: BorderSide(width: 0.2, color: Colors.black87),
          bottom: BorderSide(width: 0.2, color: Colors.black87),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ព័ត៌មានលម្អិតរបស់អតិថិជន',
              style: GoogleFonts.khmer(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('John Say'),
            SizedBox(height: 5),
            Text('+855 123456789'),
            SizedBox(height: 5),
            Text('123 Main st, New York, NY 10001'),
          ],
        ),
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'របស់របរ',
              style: GoogleFonts.khmer(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('1.'),
                        SizedBox(width: 5),
                        Text('Phone Case'),
                      ],
                    ),
                    Text(
                      '\$19.99',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text('\$19.99 x 1', style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('2.'),
                        SizedBox(width: 5),
                        Text('Phone Case'),
                      ],
                    ),
                    Text(
                      '\$19.99',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text('\$19.99 x 1', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: Border(
          top: BorderSide(width: 0.2),
          bottom: BorderSide(width: 0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('តម្លៃរង', style: GoogleFonts.khmer(fontSize: 15)),
                Text(
                  '\$109.89',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ពន្ធ​​​​ (០%)', style: GoogleFonts.khmer(fontSize: 15)),
                Text(
                  '\$0.00',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'សរុប',
                  style: GoogleFonts.khmer(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$0.00',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThanakYou() {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                'សូមអរគុណចំពោះអាជីវកម្មរបស់អ្នក!',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'នេះ​ជា​វិក្កយបត្រ​ដែល​បង្កើត​ដោយ​ស្វ័យប្រវត្តិ',
                style: GoogleFonts.khmer(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrintAndShareButtom() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                ),
              ),
              onPressed: () {},
              label: Text('Print', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.print_rounded, color: Colors.black),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                ),
              ),
              onPressed: () {},
              label: Text(
                'ចែករំលែក',
                style: GoogleFonts.khmer(fontSize: 15, color: Colors.white),
              ),
              icon: Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
