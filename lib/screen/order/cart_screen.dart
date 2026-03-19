import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_responsive/screen/order/customer_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.withOpacity(0.04),
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
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios),
              ),
              Text(
                'រទេះទំនិញ',
                style: GoogleFonts.khmer(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.blue),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 15,
                    right: 5,
                  ),
                  child: Row(
                    children: [
                      Text('Jonh Sey'),
                      SizedBox(width: 20),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerScreen()),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListProduct() {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ឈ្មោះផលិតផល',
                                style: GoogleFonts.khmer(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '\$ 19.19',
                                    style: GoogleFonts.khmer(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.edit, size: 17),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    child: Icon(Icons.remove),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Subtotal: \$1234444',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.restore_from_trash_rounded, color: Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitSection() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10.0,
          bottom: 15,
          top: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPrice(),
            SizedBox(height: 10),
            _buildCustomer(),
            SizedBox(height: 10),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black12),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('សរុបរង', style: GoogleFonts.khmer(fontSize: 15)),
                Text(
                  '120000 រ',
                  style: GoogleFonts.khmer(fontSize: 15, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(thickness: 1),
            SizedBox(height: 5),
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
                  '120000 រ',
                  style: GoogleFonts.khmer(fontSize: 18, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.green.withOpacity(0.15),
        border: Border.all(color: Colors.green),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'អតិថិជន',
              style: GoogleFonts.khmer(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Jonh Sey',
              style: GoogleFonts.khmer(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {},
      child: Text(
        'បញ្ជូន',
        style: GoogleFonts.khmer(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
