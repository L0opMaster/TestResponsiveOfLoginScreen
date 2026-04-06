import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/provider/category_provider.dart';
import 'package:test_responsive/provider/product_provider.dart';

class ProductForm extends StatefulWidget {
  final ProductModel? product;
  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  bool get isEdit => widget.product != null;

  final _categoryNoti = ValueNotifier<String?>(null);
  final _typeNoti = ValueNotifier<String?>('SALE_ITEM-ទំនិញលក់');
  final _bundleModeNoti = ValueNotifier<String?>(null);
  final _invenNoti = ValueNotifier<bool>(false);
  final _sellNoti = ValueNotifier<bool>(true);
  final _purchNoti = ValueNotifier<bool>(false);
  final _activeNoti = ValueNotifier<bool>(true);

  // TextEditingControllers
  late final TextEditingController _nameEnCtrl;
  late final TextEditingController _nameKmCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _barcodeCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _lowStockCtrl;

  // List of product type (must match backend enum)
  final List<String> productType = [
    'SALE_ITEM-ទំនិញលក់',
    'RAW_MATERIAL-វត្ថុធាតុដើម',
    'BUNDLE-បាច់',
    'SERVICE-សេវាកម្ម',
  ];

  final List<String> bundleModes = [
    'FIXED-បាច់ថេរ',
    'FLEXIBLE-បាច់បត់បែន',
  ];

  // ─── Lifecycle ─────────────────────────────────────────────────────────────
  bool _fetched = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameEnCtrl = TextEditingController(text: p?.nameEn ?? '');
    _nameKmCtrl = TextEditingController(text: p?.nameKm ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _barcodeCtrl = TextEditingController(text: p?.barcode ?? '');
    _costCtrl = TextEditingController(
      text: p != null ? p.cost.toStringAsFixed(0) : '',
    );
    _priceCtrl = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(0) : '',
    );
    _stockCtrl = TextEditingController(
      text: p != null ? p.stock.toStringAsFixed(0) : '',
    );
    _lowStockCtrl = TextEditingController(
      text: p != null ? p.lowStockThreshold.toStringAsFixed(0) : '10',
    );

    if (p != null) {
      _categoryNoti.value = p.categoryId?.toString();
      // Match productType by code prefix
      final typeCode = p.productType;
      final match = productType.cast<String?>().firstWhere(
            (t) => t!.startsWith(typeCode),
            orElse: () => null,
          );
      _typeNoti.value = match;
      _invenNoti.value = p.trackInventory;
      _sellNoti.value = p.sellable;
      _purchNoti.value = p.purchasable;
      _activeNoti.value = p.active;
      if (p.bundleMode != null) {
        final bmMatch = bundleModes.cast<String?>().firstWhere(
              (m) => m!.startsWith(p.bundleMode!),
              orElse: () => null,
            );
        _bundleModeNoti.value = bmMatch;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      context.read<CategoryProvider>().fetchCategories();
    }
  }

  @override
  void dispose() {
    _nameEnCtrl.dispose();
    _nameKmCtrl.dispose();
    _skuCtrl.dispose();
    _barcodeCtrl.dispose();
    _costCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _lowStockCtrl.dispose();
    _categoryNoti.dispose();
    _typeNoti.dispose();
    _bundleModeNoti.dispose();
    _invenNoti.dispose();
    _sellNoti.dispose();
    _purchNoti.dispose();
    _activeNoti.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.khmer()),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Map<String, dynamic> _buildBody() {
    final type = _typeNoti.value;
    final typeCode = type != null ? type.split('-').first : 'SALE_ITEM';

    final body = <String, dynamic>{
      'sku': _skuCtrl.text.trim(),
      'barcode': _barcodeCtrl.text.trim(),
      'nameEn': _nameEnCtrl.text.trim(),
      'nameKm': _nameKmCtrl.text.trim(),
      'cost': double.tryParse(_costCtrl.text.trim()) ?? 0,
      'price': double.tryParse(_priceCtrl.text.trim()) ?? 0,
      'productType': typeCode,
      'lowStockThreshold': double.tryParse(_lowStockCtrl.text.trim()) ?? 5,
      'trackInventory': _invenNoti.value,
      'sellable': _sellNoti.value,
      'purchasable': _purchNoti.value,
      'active': _activeNoti.value,
      'categoryId': int.parse(_categoryNoti.value!),
    };

    if (typeCode == 'BUNDLE' && _bundleModeNoti.value != null) {
      body['bundleMode'] = _bundleModeNoti.value!.split('-').first;
    }

    return body;
  }

  Future<void> _submitForm() async {
    final nameEn = _nameEnCtrl.text.trim();
    if (nameEn.isEmpty) {
      _showSnackBar('សូមបំពេញឈ្មោះផលិតផល (English)', success: false);
      return;
    }
    if (_nameKmCtrl.text.trim().isEmpty) {
      _showSnackBar('សូមបំពេញឈ្មោះផលិតផល (Khmer)', success: false);
      return;
    }
    if (_skuCtrl.text.trim().isEmpty) {
      _showSnackBar('សូមបំពេញ SKU', success: false);
      return;
    }
    if (_barcodeCtrl.text.trim().isEmpty) {
      _showSnackBar('សូមបំពេញលេខកូដទំនិញ', success: false);
      return;
    }
    if (_categoryNoti.value == null) {
      _showSnackBar('សូមជ្រើសរើសប្រភេទ', success: false);
      return;
    }
    final typeCode = _typeNoti.value?.split('-').first;
    if (typeCode == 'BUNDLE' && _bundleModeNoti.value == null) {
      _showSnackBar('សូមជ្រើសរើសរបៀបបាច់', success: false);
      return;
    }

    final body = _buildBody();
    final provider = context.read<ProductProvider>();

    bool success;
    if (isEdit) {
      success = await provider.updateProduct(widget.product!.id, body);
    } else {
      success = await provider.createProduct(body);
    }

    if (!mounted) return;

    if (success) {
      _showSnackBar(
        isEdit ? 'បានកែប្រែផលិតផលបានជោគជ័យ' : 'បានបង្កើតផលិតផលបានជោគជ័យ',
      );
      Navigator.pop(context);
    } else {
      _showSnackBar(
        provider.errorMessage ?? 'មានកំហុស សូមព្យាយាមម្តងទៀត',
        success: false,
      );
    }
  }

  // ─── Build helpers ────────────────────────────────────────────────────────

  Widget _buildTextfield(
    String topTitle,
    String hintText,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topTitle,
          style: GoogleFonts.khmer(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _decoration(hintText),
        ),
      ],
    );
  }

  InputDecoration _decoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.khmer(fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          isEdit ? 'កែប្រែផលិតផល' : 'បង្កើតផលិតផល',
          style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      _buildCardInfor(
                        'ព័ត៌មានមូលដ្ឋាន',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTextfield(
                              'ឈ្មោះផលិតផល​​ (English)',
                              'បញ្ចូលឈ្មោះផលិតផល​',
                              _nameEnCtrl,
                            ),
                            const SizedBox(height: 10),
                            _buildTextfield(
                              'ឈ្មោះផលិតផល​​ (Khmer)',
                              'បញ្ចូលឈ្មោះផលិតផល​',
                              _nameKmCtrl,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextfield(
                                    'SKU',
                                    'SKU-001',
                                    _skuCtrl,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: _buildTextfield(
                                    'លេខកូដទំនិញ',
                                    '1234567890',
                                    _barcodeCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'រូបភាពនៃផលិតផល',
                              style: GoogleFonts.khmer(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusGeometry.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(
                                Icons.upload,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              label: Text(
                                'បញ្ចូលរូបភាព',
                                style: GoogleFonts.khmer(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCardInfor(
                        'តម្លៃ',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextfield(
                                    'តម្លៃទិញចូល​​ (​៛)',
                                    '0.00 រ',
                                    _costCtrl,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _buildTextfield(
                                    'តម្លៃលក់ចេញ (៛)',
                                    '0.00 រ',
                                    _priceCtrl,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Resolved Price',
                              style: GoogleFonts.khmer(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Auto calculated: Uses price if set, otherwise, uses cost',
                              style: GoogleFonts.khmer(
                                fontSize: 12,
                                color:
                                    Colors.blueAccent.shade400.withAlpha(200),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCardInfor(
                        'ប្រភេទនៃទំនិញ និងទំនិញ',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Consumer<CategoryProvider>(
                              builder: (context, categoryProvider, _) {
                                final categories = categoryProvider.categories
                                    .where((c) => c.id != 0)
                                    .toList();

                                if (categoryProvider.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ប្រភេទ',
                                      style: GoogleFonts.khmer(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'ជ្រើសរើសប្រភេទ',
                                          style: GoogleFonts.khmer(
                                            fontSize: 13,
                                          ),
                                        ),
                                        valueListenable: _categoryNoti,
                                        items: categories
                                            .map(
                                              (cat) => DropdownItem<String>(
                                                value: cat.id.toString(),
                                                child: Text(
                                                  cat.nameKm,
                                                  style: GoogleFonts.khmer(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          _categoryNoti.value = value;
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Theme.of(context).dividerColor,
                                            ),
                                          ),
                                        ),
                                        dropdownStyleData:
                                            DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'ប្រភេតនៃទំនិញ',
                              style: GoogleFonts.khmer(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                valueListenable: _typeNoti,
                                onChanged: (value) {
                                  _typeNoti.value = value;
                                  if (value?.split('-').first != 'BUNDLE') {
                                    _bundleModeNoti.value = null;
                                  }
                                },
                                isDense: true,
                                hint: Text(
                                  'ជ្រើសរើសប្រភេទ',
                                  style: GoogleFonts.khmer(fontSize: 13),
                                ),
                                items: productType
                                    .map(
                                      (type) => DropdownItem<String>(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: GoogleFonts.khmer(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                buttonStyleData: ButtonStyleData(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Theme.of(context).dividerColor),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            ValueListenableBuilder<String?>(
                              valueListenable: _typeNoti,
                              builder: (context, typeValue, _) {
                                if (typeValue?.split('-').first != 'BUNDLE') {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'របៀបបាច់',
                                      style: GoogleFonts.khmer(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        valueListenable: _bundleModeNoti,
                                        onChanged: (value) {
                                          _bundleModeNoti.value = value;
                                        },
                                        isDense: true,
                                        hint: Text(
                                          'ជ្រើសរើសរបៀបបាច់',
                                          style:
                                              GoogleFonts.khmer(fontSize: 13),
                                        ),
                                        items: bundleModes
                                            .map(
                                              (mode) => DropdownItem<String>(
                                                value: mode,
                                                child: Text(
                                                  mode,
                                                  style: GoogleFonts.khmer(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        buttonStyleData: ButtonStyleData(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey),
                                          ),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCardInfor(
                        'ស្កុក',
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextfield(
                                    'បរិមាណស្តុក',
                                    '0',
                                    _stockCtrl,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _buildTextfield(
                                    'អំពីបរិមាណស្តុកទាប',
                                    '10',
                                    _lowStockCtrl,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(thickness: 2),
                            const SizedBox(height: 5),
                            _toogleSwich(
                              'Track Inventory',
                              'Monitor stock level',
                              false,
                              _invenNoti,
                            ),
                            _toogleSwich(
                              'Sellable',
                              'Available for sale',
                              false,
                              _sellNoti,
                            ),
                            _toogleSwich(
                              'Purchasable',
                              'Can be purchased',
                              false,
                              _purchNoti,
                            ),
                            _toogleSwich(
                              'Active',
                              'Product',
                              true,
                              _activeNoti,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              final isSubmitting = isEdit ? provider.isUpdate : provider.isCreate;
              return Container(
                height: 70,
                padding: const EdgeInsets.all(15),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  onPressed: isSubmitting ? null : _submitForm,
                  label: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEdit ? 'រក្សាទុកការកែប្រែ' : 'បង្កើតផលិតផល',
                          style: GoogleFonts.khmer(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                  icon: isSubmitting
                      ? const SizedBox.shrink()
                      : const Icon(Icons.save_outlined, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _toogleSwich(
    String title,
    String subTitle,
    bool isShow,
    ValueNotifier<bool> toogle,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: toogle,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.khmer(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subTitle, style: GoogleFonts.khmer(fontSize: 11)),
              ],
            ),
            Row(
              children: [
                if (isShow)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: value
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10,
                      ),
                      child: Text(
                        value ? 'សកម្ម' : 'អសកម្ម',
                        style: GoogleFonts.khmer(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: value,
                    onChanged: (v) => toogle.value = v,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardInfor(String mainTitle, Widget formdetail) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (mainTitle.isNotEmpty)
              Text(
                mainTitle,
                style: GoogleFonts.khmer(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            formdetail,
          ],
        ),
      ),
    );
  }
}
