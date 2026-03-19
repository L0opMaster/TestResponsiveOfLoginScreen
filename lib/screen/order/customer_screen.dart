import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blue.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopContent(context),
              _buildCreateCustomer(),
              _buildListCustomer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          Text(
            'បញ្ចីអតិថិជន',
            style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateCustomer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'បង្កើតអតិថិជនថ្មី',
              style: GoogleFonts.khmer(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text('ឈ្មោះ', style: GoogleFonts.khmer(fontSize: 15)),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                isDense: true,
                hintText: 'ឈ្មោះអតិថិជន',
                hintStyle: GoogleFonts.khmer(fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('លេខទូរសព្ទ', style: GoogleFonts.khmer(fontSize: 15)),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                isDense: true,
                // labelText: 'ឈ្មោះអតិថិជន',
                hintStyle: GoogleFonts.khmer(fontSize: 15),
                hintText: '+ 855 1234555',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('អាសយដ្ឋាន', style: GoogleFonts.khmer(fontSize: 15)),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                isDense: true,
                hintText: 'អាសយដ្ឋាន',
                hintStyle: GoogleFonts.khmer(fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                minimumSize: Size(2000, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                'បង្កើត',
                style: GoogleFonts.khmer(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCustomer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SizedBox(
          child: ListView.builder(
            itemCount: 20,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ឈ្មោះអតិថិជន',
                            style: GoogleFonts.khmer(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('+855 16474665'),
                          SizedBox(height: 5),
                          Text('st 460 Oak Ave, Los Angeles, CA'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
