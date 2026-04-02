import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/provider/category_provider.dart';
import 'package:test_responsive/screen/category/category_form.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ប្រភេទនៃទំនិញ',
          style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildButtonCreateCategory(context),
            SizedBox(height: 20),
            Expanded(child: _buildListOfCategories()),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonCreateCategory(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryForm()),
        );
      },
      icon: Icon(Icons.add, color: Colors.black, size: 25),
      label: Text(
        'បង្កើតប្រភេទទំនិញថ្មី',
        style: GoogleFonts.khmer(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListOfCategories() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.categories.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.category_outlined, color: Colors.blueAccent),
                const SizedBox(height: 10),
                Text(
                  'ស្វែងរកប្រភេទទំនិញមិនឃើញ',
                  style: GoogleFonts.khmer(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.categories.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final categories = provider.categories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categories.nameEn,
                            style: GoogleFonts.khmer(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(categories.nameKm),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          categories.active
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen.shade100
                                        .withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'សកម្ម',
                                      style: GoogleFonts.khmer(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'អសកម្ម',
                                      style: GoogleFonts.khmer(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
