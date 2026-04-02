import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/provider/category_provider.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _statusNotifier = ValueNotifier<bool>(false);

  // Create categories info
  final _nameKm = TextEditingController();
  final _nameEn = TextEditingController();
  final _parentId = TextEditingController();

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _statusNotifier.dispose();
    _nameEn.dispose();
    _nameKm.dispose();
    _parentId.dispose();
    super.dispose();
  }
  // ─── Helpers ───────────────────────────────────────────────────────────────

  // Show a green or red [SnackBar] with [message]
  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.khmer()),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // Build the request body map from the current create-form state.
  Map<String, dynamic> _buildBody({
    required String nameKm,
    required TextEditingController nameEn,
    required TextEditingController parentId,
    required bool isActive,
  }) {
    return {
      'nameKm': nameKm,
      'nameEn': nameEn.text.trim(),
      if (parentId.text.isNotEmpty) 'parentId': int.parse(parentId.text.trim()),
      'active': isActive,
    };
  }

  // Clear all create-form fields and resets
  void _clearForm() {
    _nameEn.clear();
    _nameKm.clear();
    _parentId.clear();
    _statusNotifier.value = false;
  }

  // ─── Actions ─────────────────────────────────────────────────────────────

  // Validates the create form, call [Categories.createCategory],
  // clears the form on success, and show a feedback snackbar.
  Future<void> _submitCreate() async {
    final nameKm = _nameKm.text.trim();
    if (nameKm.isEmpty) {
      _showSnackBar('សូមបំពេញ​ ឈ្មោះប្រភេទនៃទំនិញជាភាសាខ្មែរ', success: false);
      return;
    }

    final body = _buildBody(
      nameKm: nameKm,
      nameEn: _nameEn,
      parentId: _parentId,
      isActive: _statusNotifier.value,
    );

    final provider = context.read<CategoryProvider>();
    final success = await provider.createCategories(body);
    if (!mounted) {
      return;
    }

    if (success) {
      _clearForm();
      _showSnackBar('បានបង្កើតប្រភេទនៃទំនិញបានជោគជ័យ');
      Navigator.pop(context);
    } else {
      _showSnackBar(
        provider.errorMessage ?? 'មានកំហុស​ ឬ បញ្ហា សូមព្យាយាមម្តងទៀត',
        success: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ទម្រង់បង្កើត',
          style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopForm(),
              const SizedBox(height: 20),
              _buildInforDetail(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Consumer<CategoryProvider>(
                  builder: (context, provider, child) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                      onPressed: provider.isCreate ? null : _submitCreate,
                      child: provider.isCreate
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'បង្កើតបានជោគជ័យ',
                              style: GoogleFonts.khmer(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopForm() {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.shade400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'បង្កើតប្រភេទទំនិញថ្មី',
              style: GoogleFonts.khmer(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'បំពេញពត៌មានលម្អិត',
              style: GoogleFonts.khmer(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInforDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ឈ្មោះ(Kh)',
                      style: GoogleFonts.khmer(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: _nameKm,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'ឈ្មោះជាភាសាខ្មែរ',
                        hintStyle: GoogleFonts.khmer(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ឈ្មោះ(En)',
                      style: GoogleFonts.khmer(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    TextField(
                      controller: _nameEn,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'ឈ្មោះជាភាសាខ្មែរ',
                        hintStyle: GoogleFonts.khmer(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'លេខយោង (parent id)',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              TextField(
                controller: _parentId,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'លេខយោង parentId',
                  hintStyle: GoogleFonts.khmer(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ស្ថានភាព',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _statusNotifier,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: _statusNotifier.value,
                      onChanged: (value) {
                        setState(() {
                          _statusNotifier.value = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
