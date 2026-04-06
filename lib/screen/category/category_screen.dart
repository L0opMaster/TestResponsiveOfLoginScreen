import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/category_model.dart';
import 'package:test_responsive/provider/category_provider.dart';
import 'package:test_responsive/screen/category/category_form.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // _fetched – flag to ensure we only fetch data once, not on every rebuild.
  bool _fetched = false;

  // didChangeDependencies – called after initState and whenever dependencies change.
  // We use this instead of initState because context.read() is safe to call here.
  // Previously, data was fetched in main.dart at app startup (CategoryProvider()..fetchCategories()).
  // Now each screen fetches its own data when opened — faster app start, less memory usage.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      // Fetch categories from API only once when this screen opens.
      context.read<CategoryProvider>().fetchCategories();
    }
  }

  // --- Helper Snackbar
  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.khmer()),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // build the request body map from current form state.
  Map<String, dynamic> _buildBody({
    required String nameKm,
    required String nameEn,
    required TextEditingController parentId,
    required bool active,
  }) {
    return {
      'nameKm': nameKm,
      'nameEn': nameEn,
      if (parentId.text.isEmpty) 'parentId': int.parse(parentId.text.trim()),
      'active': active,
    };
  }

  void _showEditSheet(CategoryModel categories) {
    // Local controller pre-filled wiht exist date.
    final nameEnCtrl = TextEditingController(text: categories.nameEn);
    final nameKmCtrl = TextEditingController(text: categories.nameKm);
    final parentIdCtrl = TextEditingController(
      text: categories.parentId.toString(),
    );
    final isActive = ValueNotifier<bool>(categories.active);

    // FocusNodes for each TextField in the edit sheet –
    // allows moving focus from one field to the next on submit.
    final nameKmFocus = FocusNode();
    final nameEnFocus = FocusNode();
    final parentIdFocus = FocusNode();

    showModalBottomSheet(
      context: context,
      // isScrollControlled: true – lets the sheet grow with the keyboard.
      // Using AnimatedPadding instead of Padding prevents focus loss when
      // the user switches keyboard language (viewInsets changes briefly).
      isScrollControlled: true,
      builder: (context) => AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Sheet title ──────────────────────────────────────────
              Text(
                'កែប្រែប្រភេទទំនិញ',
                style: GoogleFonts.khmer(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // ── Name in Khmer ──────────────────────────────────────────
              Text(
                'ឈ្មោះ (Kh)',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // autofocus: true – auto-focuses this field when the bottom sheet opens.
              // focusNode: nameKmFocus – attach FocusNode to control focus.
              // onSubmitted – when user presses "done/enter", move focus to nameEn.
              TextField(
                controller: nameKmCtrl,
                focusNode: nameKmFocus,
                autofocus: true,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => nameEnFocus.requestFocus(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'ឈ្មោះជាភាសាខ្មែរ',
                  hintStyle: GoogleFonts.khmer(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // ── Name in English ──────────────────────────────────────────
              Text(
                'ឈ្មោះ (En)',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // focusNode: nameEnFocus – receives focus from nameKm field.
              // onSubmitted – when user presses "done/enter", move focus to parentId.
              TextField(
                controller: nameEnCtrl,
                focusNode: nameEnFocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => parentIdFocus.requestFocus(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'ឈ្មោះជាភាសាអង់គ្លេស',
                  hintStyle: GoogleFonts.khmer(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // ── ParentId ──────────────────────────────────────────
              Text(
                'លេខយោង (parentId)',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // focusNode: parentIdFocus – receives focus from nameEn field.
              // textInputAction: done – shows "done" button since this is the last field.
              // onSubmitted – unfocus (dismiss keyboard) when user presses "done".
              TextField(
                controller: parentIdCtrl,
                focusNode: parentIdFocus,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => parentIdFocus.unfocus(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'លេខយោង (parentId)',
                  hintStyle: GoogleFonts.khmer(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // ── Status ──────────────────────────────────────────
              Text(
                'ស្ថានភាព (សកម្ម / មិនសកម្ម)',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: isActive,
                builder: (context, val, child) => Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue.shade300,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isActive.value ? 'សកម្ម' : 'អសកម្ម',
                        style: GoogleFonts.khmer(fontSize: 15),
                      ),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: isActive.value,
                          onChanged: (value) => isActive.value = value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ── Save button ──────────────────────────────────────────
              Consumer<CategoryProvider>(
                builder: (context, provider, child) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                    ),
                    onPressed: provider.isUpdate
                        ? null
                        : () async {
                            final nameKh = nameKmCtrl.text.trim();
                            final nameEn = nameEnCtrl.text.trim();
                            // Validate required fields before sending.
                            if (nameKh.isEmpty) {
                              _showSnackBar(
                                'សូមបំពេញឈ្មោះនៃប្រភេទ',
                                success: false,
                              );
                              return;
                            }

                            final body = _buildBody(
                              nameKm: nameKh,
                              nameEn: nameEn,
                              parentId: parentIdCtrl,
                              active: isActive.value,
                            );
                            final success = await provider.updateCategories(
                              categories.id,
                              body,
                            );
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            _showSnackBar(
                              success
                                  ? 'បានកែប្រែដោយជោគជ័យ'
                                  : (provider.errorMessage ?? 'មានបញ្ហា'),
                              success: success,
                            );
                          },
                    child: provider.isUpdate
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeAlign: 2,
                            ),
                          )
                        : Text(
                            'រក្សាទុក',
                            style: GoogleFonts.khmer(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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

  // Delete Categories
  /// Shows a confirmation [AlertDialog] then calls
  /// [CategoryProvider.deleteCategory] if the user confirms.
  Future<void> _confirmDelete(CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'លុបប្រភេទទំនិញ',
          style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'តើអ្នកប្រាកដទេថាចង់លុប ${category.nameKm}?',
          style: GoogleFonts.khmer(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('បោះបង់', style: GoogleFonts.khmer()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text('លុប', style: GoogleFonts.khmer(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<CategoryProvider>();
    final success = await provider.deletedCategories(category.id);
    if (!mounted) return;

    _showSnackBar(
      success
          ? 'លុបប្រភេទទំនិញបានដោយជោគជ័យ'
          : (provider.errorMessage ?? 'មានបញ្ហា'),
      success: success,
    );
  }

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
        return Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ListView.builder(
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
                            Text(
                              categories.nameKm,
                              style: GoogleFonts.khmer(fontSize: 12),
                            ),
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
                                      color: Colors.red.shade100.withOpacity(
                                        0.6,
                                      ),
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
                                  onPressed: () => _showEditSheet(categories),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                IconButton(
                                  onPressed: () => _confirmDelete(categories),
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
          ),
        );
      },
    );
  }
}
