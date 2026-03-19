import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PackgingScreen extends StatelessWidget {
  const PackgingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopContent(),
              _buildCategory(),
              SizedBox(height: 15),
              _buildListOrder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'បញ្ចីវេចខ្ចប់',
        style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategory() {
    return SizedBox(
      child: Row(
        children: [
          _categoryButtom('ទាំងអស់'),
          _categoryButtom('កំពុងរៀបចំ'),
          _categoryButtom('រៀបរួច'),
        ],
      ),
    );
  }

  Widget _buildListOrder() {
    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Card(
                elevation: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ORD-161682',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.withOpacity(0.1),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outlined,
                                        color: Colors.green.shade800,
                                        size: 15,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'រៀបរួច',
                                        style: GoogleFonts.khmer(
                                          fontSize: 10,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.black54,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Mar 18, 09:49 AM',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.person, size: 15),
                                SizedBox(width: 10),
                                Text('Jonh Sey'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        border: Border(
                          top: BorderSide(width: 0.9, color: Colors.black54),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'បង្ហាញផលិតផល',
                              style: GoogleFonts.khmer(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 1),
                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'តម្លៃសរុប',
                                  style: GoogleFonts.khmer(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$ 123.00',
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red),
                                borderRadius: BorderRadiusGeometry.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            label: Text(
                              'កំពុងរៀបចំ',
                              style: GoogleFonts.khmer(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            icon: Icon(Icons.timer_outlined, color: Colors.red),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.greenAccent),
                                borderRadius: BorderRadiusGeometry.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            label: Text(
                              'កំពុងរៀបចំ',
                              style: GoogleFonts.khmer(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            icon: Icon(
                              Icons.check_circle_outline_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _categoryButtom(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.black45),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(title),
        ),
      ),
    );
  }
}
