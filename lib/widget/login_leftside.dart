import 'package:flutter/material.dart';
import 'package:test_responsive/common_widget/featurebox.dart';

class LoginLeftside extends StatelessWidget {
  const LoginLeftside({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth < 701 ? 200 : 300;
    return SizedBox(
      width: boxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_topContent(), SizedBox(height: 60), _bottomContent()],
      ),
    );
  }

  Widget _bottomContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FeatureBox(
          title: 'Fast Checkout',
          subtitle: 'Barcode ready, discount, tax, and receipts.',
        ),
        SizedBox(height: 10),
        FeatureBox(
          title: 'Inventory',
          subtitle: 'Real-time stock, low alerts, and tralsfers.',
        ),
        SizedBox(height: 10),
        FeatureBox(
          title: 'Role-based access',
          subtitle: 'Owner, manager, cashier, workflows.',
        ),
      ],
    );
  }

  Widget _topContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4),
            child: Text(
              'Cambodia-line POS',
              style: TextStyle(
                fontSize: 9,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        // Kaknnea POS
        Text(
          'KAKNNEA POS',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: Text(
            'Run checkout, inventory, and staff control in one fast, reliable system.',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}
