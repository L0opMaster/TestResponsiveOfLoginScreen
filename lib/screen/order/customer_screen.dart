import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/customer_model.dart';
import 'package:test_responsive/provider/customer_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CustomerScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Main screen for managing customers.
///
/// Displays a tabbed create-customer form at the top and a scrollable
/// list of existing customers below. Each list item supports edit and delete.
class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  // ─── Tab state ─────────────────────────────────────────────────────────────

  /// Currently active tab index in the create-customer form.
  int _selectedTab = 0;

  /// Tab definitions: label (Khmer) + icon.
  final List<Map<String, dynamic>> _tabLabels = [
    {'label': 'មូលដ្ឋាន', 'icon': Icons.person},
    {'label': 'ទំនាក់ទំនង', 'icon': Icons.contact_page},
    {'label': 'ហិរញ្ញវត្ថុ', 'icon': Icons.monetization_on_rounded},
    {'label': 'ឥណទាន', 'icon': Icons.credit_card},
  ];

  // ─── Dropdown options ──────────────────────────────────────────────────────

  /// Customer type options stored and sent as Khmer strings.
  final List<String> _typeOptions = ['បុគ្គល', 'អាជីវកម្ម', 'លក់រាយ', 'លក់ដុំ'];

  /// Customer status options stored and sent as Khmer strings.
  final List<String> _statusOptions = ['សកម្ម', 'មិនសកម្ម'];

  // ─── Create-form notifiers & controllers ───────────────────────────────────

  final _typeNotifier = ValueNotifier<String?>(null);
  final _statusNotifier = ValueNotifier<String?>(null);
  final _creditHoldNotifier = ValueNotifier<bool>(false);

  // Basic info
  final _codeCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _nameEnCtrl = TextEditingController();
  final _nameKmCtrl = TextEditingController();

  // Contact info
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _contactPersonCtrl = TextEditingController();

  // Financial info
  final _taxNumberCtrl = TextEditingController();
  final _paymentTermsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // Credit info
  final _creditLimitCtrl = TextEditingController();
  final _creditBalanceCtrl = TextEditingController();

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Fetch customers after the first frame so the provider is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().fetchCustomers();
    });
  }

  @override
  void dispose() {
    _typeNotifier.dispose();
    _statusNotifier.dispose();
    _creditHoldNotifier.dispose();
    _codeCtrl.dispose();
    _displayNameCtrl.dispose();
    _nameEnCtrl.dispose();
    _nameKmCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _contactPersonCtrl.dispose();
    _taxNumberCtrl.dispose();
    _paymentTermsCtrl.dispose();
    _notesCtrl.dispose();
    _creditLimitCtrl.dispose();
    _creditBalanceCtrl.dispose();
    super.dispose();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Reusable [InputDecoration] used by all TextFields in this screen.
  InputDecoration _inputDecoration(String hint) => InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: GoogleFonts.khmer(fontSize: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );

  /// Shows a green or red [SnackBar] with [message].
  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.khmer()),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  /// Clears all create-form fields and resets dropdowns.
  void _clearForm() {
    _codeCtrl.clear();
    _displayNameCtrl.clear();
    _nameEnCtrl.clear();
    _nameKmCtrl.clear();
    _phoneCtrl.clear();
    _emailCtrl.clear();
    _addressCtrl.clear();
    _contactPersonCtrl.clear();
    _taxNumberCtrl.clear();
    _paymentTermsCtrl.clear();
    _notesCtrl.clear();
    _creditLimitCtrl.clear();
    _creditBalanceCtrl.clear();
    _typeNotifier.value = null;
    _statusNotifier.value = null;
    _creditHoldNotifier.value = false;
  }

  /// Builds the request body map from the current create-form state.
  Map<String, dynamic> _buildBody({
    required String code,
    required String type,
    required String status,
    required TextEditingController displayName,
    required TextEditingController nameEn,
    required TextEditingController nameKm,
    required TextEditingController phone,
    required TextEditingController email,
    required TextEditingController address,
    required TextEditingController contactPerson,
    required TextEditingController taxNumber,
    required TextEditingController paymentTerms,
    required TextEditingController notes,
    required TextEditingController creditLimit,
    required TextEditingController creditBalance,
    required bool creditHold,
  }) {
    return {
      'code': code,
      'type': type,
      'status': status,
      if (displayName.text.isNotEmpty) 'displayName': displayName.text.trim(),
      if (nameEn.text.isNotEmpty) 'nameEn': nameEn.text.trim(),
      if (nameKm.text.isNotEmpty) 'nameKm': nameKm.text.trim(),
      if (phone.text.isNotEmpty) 'phone': phone.text.trim(),
      if (email.text.isNotEmpty) 'email': email.text.trim(),
      if (address.text.isNotEmpty) 'address': address.text.trim(),
      if (contactPerson.text.isNotEmpty)
        'contactPerson': contactPerson.text.trim(),
      if (taxNumber.text.isNotEmpty) 'taxNumber': taxNumber.text.trim(),
      if (paymentTerms.text.isNotEmpty)
        'paymentTerms': paymentTerms.text.trim(),
      if (notes.text.isNotEmpty) 'notes': notes.text.trim(),
      'creditLimit': double.tryParse(creditLimit.text) ?? 0.0,
      'creditBalance': double.tryParse(creditBalance.text) ?? 0.0,
      'creditHold': creditHold,
    };
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  /// Validates the create form, calls [CustomerProvider.createCustomer],
  /// clears the form on success, and shows a feedback snackbar.
  Future<void> _submitCreate() async {
    final code = _codeCtrl.text.trim();
    final typeLabel = _typeNotifier.value;
    final statusLabel = _statusNotifier.value;

    if (code.isEmpty || typeLabel == null || statusLabel == null) {
      _showSnackBar('សូមបំពេញ លេខសម្គាល់, ប្រភេទ និង ស្ថានភាព', success: false);
      return;
    }

    final body = _buildBody(
      code: code,
      type: typeLabel,
      status: statusLabel,
      displayName: _displayNameCtrl,
      nameEn: _nameEnCtrl,
      nameKm: _nameKmCtrl,
      phone: _phoneCtrl,
      email: _emailCtrl,
      address: _addressCtrl,
      contactPerson: _contactPersonCtrl,
      taxNumber: _taxNumberCtrl,
      paymentTerms: _paymentTermsCtrl,
      notes: _notesCtrl,
      creditLimit: _creditLimitCtrl,
      creditBalance: _creditBalanceCtrl,
      creditHold: _creditHoldNotifier.value,
    );

    final provider = context.read<CustomerProvider>();
    final success = await provider.createCustomer(body);
    if (!mounted) return;

    if (success) {
      _clearForm();
      _showSnackBar('បានបង្កើតអតិថិជនដោយជោគជ័យ');
    } else {
      _showSnackBar(
        provider.errorMessage ?? 'មានបញ្ហា សូមព្យាយាមម្តងទៀត',
        success: false,
      );
    }
  }

  /// Shows a confirmation [AlertDialog] then calls
  /// [CustomerProvider.deleteCustomer] if the user confirms.
  Future<void> _confirmDelete(CustomerModel customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'លុបអតិថិជន',
          style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'តើអ្នកប្រាកដទេថាចង់លុប "${customer.displayName ?? customer.nameKm ?? customer.code}"?',
          style: GoogleFonts.khmer(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('បោះបង់', style: GoogleFonts.khmer()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('លុប', style: GoogleFonts.khmer(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<CustomerProvider>();
    final success = await provider.deleteCustomer(customer.id);
    if (!mounted) return;

    _showSnackBar(
      success
          ? 'បានលុបអតិថិជនដោយជោគជ័យ'
          : (provider.errorMessage ?? 'មានបញ្ហា'),
      success: success,
    );
  }

  /// Opens a scrollable bottom sheet pre-filled with [customer] data.
  /// On save, calls [CustomerProvider.updateCustomer].
  void _showEditSheet(CustomerModel customer) {
    // Use the stored Khmer value directly — no reverse-lookup needed.
    final typeLabel = _typeOptions.contains(customer.type)
        ? customer.type
        : _typeOptions.first;
    final statusLabel = _statusOptions.contains(customer.status)
        ? customer.status
        : _statusOptions.first;

    // Local controllers pre-filled with existing data.
    final codeCtrl = TextEditingController(text: customer.code);
    final displayNameCtrl = TextEditingController(
      text: customer.displayName ?? '',
    );
    final nameEnCtrl = TextEditingController(text: customer.nameEn ?? '');
    final nameKmCtrl = TextEditingController(text: customer.nameKm ?? '');
    final phoneCtrl = TextEditingController(text: customer.phone ?? '');
    final emailCtrl = TextEditingController(text: customer.email ?? '');
    final addressCtrl = TextEditingController(text: customer.address ?? '');
    final contactPersonCtrl = TextEditingController(
      text: customer.contactPerson ?? '',
    );
    final taxNumberCtrl = TextEditingController(text: customer.taxNumber ?? '');
    final paymentTermsCtrl = TextEditingController(
      text: customer.paymentTerms ?? '',
    );
    final notesCtrl = TextEditingController(text: customer.notes ?? '');
    final creditLimitCtrl = TextEditingController(
      text: customer.creditLimit.toString(),
    );
    final creditBalanceCtrl = TextEditingController(
      text: customer.creditBalance.toString(),
    );

    final editTypeNotifier = ValueNotifier<String?>(typeLabel);
    final editStatusNotifier = ValueNotifier<String?>(statusLabel);
    final editCreditHoldNotifier = ValueNotifier<bool>(customer.creditHold);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Sheet title ──────────────────────────────────────────
              Text(
                'កែប្រែអតិថិជន',
                style: GoogleFonts.khmer(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // ── Code ─────────────────────────────────────────────────
              Text(
                'លេខសម្គាល់ *',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: codeCtrl,
                decoration: _inputDecoration('CUST001'),
              ),
              const SizedBox(height: 10),

              // ── Type & Status dropdowns ───────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _editDropdown(
                      'ប្រភេទ',
                      _typeOptions,
                      editTypeNotifier,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _editDropdown(
                      'ស្ថានភាព',
                      _statusOptions,
                      editStatusNotifier,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Names ────────────────────────────────────────────────
              Text(
                'ឈ្មោះបង្ហាញ',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: displayNameCtrl,
                decoration: _inputDecoration('ឈ្មោះចូលចិត្ត'),
              ),
              const SizedBox(height: 10),
              Text(
                'ឈ្មោះ (En)',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: nameEnCtrl,
                decoration: _inputDecoration('English name'),
              ),
              const SizedBox(height: 10),
              Text(
                'ឈ្មោះ (Kh)',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: nameKmCtrl,
                decoration: _inputDecoration('ឈ្មោះខ្មែរ'),
              ),
              const SizedBox(height: 10),

              // ── Contact ──────────────────────────────────────────────
              Text(
                'លេខទូរស័ព្ទ',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('+855...'),
              ),
              const SizedBox(height: 10),
              Text(
                'អ៊ីម៉ែល',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('customer@email.com'),
              ),
              const SizedBox(height: 10),
              Text(
                'អាសយដ្ឌាន',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: addressCtrl,
                decoration: _inputDecoration('អាសយដ្ឋាន'),
              ),
              const SizedBox(height: 10),
              Text(
                'អ្នកទំនាក់ទំនង',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: contactPersonCtrl,
                decoration: _inputDecoration('ឈ្មោះ'),
              ),
              const SizedBox(height: 10),

              // ── Financial ────────────────────────────────────────────
              Text(
                'លេខពន្ធ',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: taxNumberCtrl,
                decoration: _inputDecoration('VAT/Tax number'),
              ),
              const SizedBox(height: 10),
              Text(
                'លក្ខខណ្ឌទូទាត់',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: paymentTermsCtrl,
                decoration: _inputDecoration('Net 30, COD...'),
              ),
              const SizedBox(height: 10),
              Text(
                'កំណត់ចំណាំ',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: notesCtrl,
                decoration: _inputDecoration('មតិ...'),
              ),
              const SizedBox(height: 10),

              // ── Credit ───────────────────────────────────────────────
              Text(
                'ដែនកំណត់ឥណទាន (\$)',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: creditLimitCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('1000'),
              ),
              const SizedBox(height: 10),
              Text(
                'សមតុល្យឥណទាន (\$)',
                style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: creditBalanceCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('0'),
              ),
              const SizedBox(height: 10),

              // ── Credit Hold toggle ───────────────────────────────────
              ValueListenableBuilder<bool>(
                valueListenable: editCreditHoldNotifier,
                builder: (context, val, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Credit Hold',
                      style: GoogleFonts.khmer(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: val,
                      onChanged: (v) => editCreditHoldNotifier.value = v,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Save button ──────────────────────────────────────────
              Consumer<CustomerProvider>(
                builder: (ctx2, provider, child) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: provider.isUpdating
                        ? null
                        : () async {
                            final tLabel = editTypeNotifier.value;
                            final sLabel = editStatusNotifier.value;

                            // Validate required fields before sending.
                            if (codeCtrl.text.trim().isEmpty ||
                                tLabel == null ||
                                sLabel == null) {
                              _showSnackBar(
                                'សូមបំពេញ លេខសម្គាល់, ប្រភេទ និង ស្ថានភាព',
                                success: false,
                              );
                              return;
                            }

                            final body = _buildBody(
                              code: codeCtrl.text.trim(),
                              type: tLabel,
                              status: sLabel,
                              displayName: displayNameCtrl,
                              nameEn: nameEnCtrl,
                              nameKm: nameKmCtrl,
                              phone: phoneCtrl,
                              email: emailCtrl,
                              address: addressCtrl,
                              contactPerson: contactPersonCtrl,
                              taxNumber: taxNumberCtrl,
                              paymentTerms: paymentTermsCtrl,
                              notes: notesCtrl,
                              creditLimit: creditLimitCtrl,
                              creditBalance: creditBalanceCtrl,
                              creditHold: editCreditHoldNotifier.value,
                            );

                            final success = await provider.updateCustomer(
                              customer.id,
                              body,
                            );
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            _showSnackBar(
                              success
                                  ? 'បានកែប្រែដោយជោគជ័យ'
                                  : (provider.errorMessage ?? 'មានបញ្ហា'),
                              success: success,
                            );
                          },
                    child: provider.isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
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

  /// Helper that builds a labelled dropdown for the edit bottom sheet.
  Widget _editDropdown(
    String label,
    List<String> options,
    ValueNotifier<String?> notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.khmer(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: options
                .map(
                  (l) => DropdownItem<String>(
                    value: l,
                    child: Text(l, style: GoogleFonts.khmer()),
                  ),
                )
                .toList(),
            valueListenable: notifier,
            onChanged: (v) => notifier.value = v,
            buttonStyleData: ButtonStyleData(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blue.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildCreateForm(),
              _buildCustomerList(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section builders ──────────────────────────────────────────────────────

  /// Back button + screen title.
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          Text(
            'បញ្ចីអតិថិជន',
            style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Tabbed card that contains the create-customer form.
  Widget _buildCreateForm() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──────────────────────────────────────────────
          Container(
            width: double.maxFinite,
            color: Colors.blue.shade400,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  'បង្កើតអតិថិជនថ្មី',
                  style: GoogleFonts.khmer(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'បំពេញពត៍មានលម្អិតអតិថិជន',
                  style: GoogleFonts.khmer(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),

          // ── Tab bar ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabLabels.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: TabItem(
                        icon: _tabLabels[i]['icon'] as IconData,
                        label: _tabLabels[i]['label'] as String,
                        isActive: _selectedTab == i,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Active tab content ───────────────────────────────────────
          _buildTabContent(_selectedTab),

          // ── Submit button ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Consumer<CustomerProvider>(
              builder: (context, provider, child) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isCreate ? null : _submitCreate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                          'បង្កើតអតិថិជន',
                          style: GoogleFonts.khmer(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Scrollable list of all customers with edit and delete actions.
  Widget _buildCustomerList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Consumer<CustomerProvider>(
          builder: (context, provider, child) {
            // ── Loading state ────────────────────────────────────────
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ── Empty state ──────────────────────────────────────────
            if (provider.customers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'មិនមានអតិថិជន',
                      style: GoogleFonts.khmer(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // ── Customer cards ───────────────────────────────────────
            return ListView.builder(
              itemCount: provider.customers.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final customer = provider.customers[index];
                return _buildCustomerCard(customer);
              },
            );
          },
        ),
      ),
    );
  }

  /// A single customer card showing avatar, info, edit and delete buttons.
  Widget _buildCustomerCard(CustomerModel customer) {
    // Derive initials from the best available name.
    final initials =
        (customer.nameKm?.isNotEmpty == true
                ? customer.nameKm![0]
                : customer.nameEn?.isNotEmpty == true
                ? customer.nameEn![0]
                : '?')
            .toUpperCase();

    final statusColor = customer.status == 'សកម្ម'
        ? Colors.green
        : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Avatar ────────────────────────────────────────────────
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                initials,
                style: GoogleFonts.khmer(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Info column ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + status badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          customer.displayName ??
                              customer.nameKm ??
                              customer.nameEn ??
                              '-',
                          style: GoogleFonts.khmer(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          customer.status,
                          style: GoogleFonts.khmer(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Code + type
                  Row(
                    children: [
                      Icon(Icons.tag, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        customer.code,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.business_center_outlined,
                        size: 13,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        customer.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Phone (optional)
                  if (customer.phone != null)
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.phone!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),

                  // Credit balance + hold indicator
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 13,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${customer.creditBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (customer.creditHold) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Credit Hold',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Action buttons ────────────────────────────────────────
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue.shade400),
                  onPressed: () => _showEditSheet(customer),
                ),
                // Delete
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: () => _confirmDelete(customer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tab content builders ──────────────────────────────────────────────────

  /// Routes to the correct tab widget based on [index].
  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _buildBasicTab();
      case 1:
        return _buildContactTab();
      case 2:
        return _buildFinancialTab();
      case 3:
        return _buildCreditTab();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Tab 0 – basic info: code, type, status, display name, names.
  Widget _buildBasicTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer code
          Text(
            'លេខសម្គាល់អតិថិជន *',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _codeCtrl,
            decoration: _inputDecoration('CUST001'),
          ),
          const SizedBox(height: 10),

          // Type & Status side by side
          Row(
            children: [
              // Type dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ប្រភេទ',
                    style: GoogleFonts.khmer(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'ជ្រើសរើស',
                        style: GoogleFonts.khmer(fontSize: 14),
                      ),
                      items: _typeOptions
                          .map(
                            (label) => DropdownItem<String>(
                              value: label,
                              child: Text(
                                label,
                                style: GoogleFonts.khmer(fontSize: 15),
                              ),
                            ),
                          )
                          .toList(),
                      valueListenable: _typeNotifier,
                      onChanged: (v) => _typeNotifier.value = v,
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Status dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ស្ថានភាព',
                      style: GoogleFonts.khmer(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'ជ្រើសរើស',
                          style: GoogleFonts.khmer(fontSize: 14),
                        ),
                        items: _statusOptions
                            .map(
                              (label) => DropdownItem<String>(
                                value: label,
                                child: Text(
                                  label,
                                  style: GoogleFonts.khmer(fontSize: 15),
                                ),
                              ),
                            )
                            .toList(),
                        valueListenable: _statusNotifier,
                        onChanged: (v) => _statusNotifier.value = v,
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Display name
          Text(
            'ឈ្មោះបង្ហាញ',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _displayNameCtrl,
            decoration: _inputDecoration('ឈ្មោះចូលចិត្ត'),
          ),
          const SizedBox(height: 10),

          // English name
          Text(
            'ឈ្មោះ (En)',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _nameEnCtrl,
            decoration: _inputDecoration('ឈ្មោះជាភាសាអង់គ្លេស'),
          ),
          const SizedBox(height: 10),

          // Khmer name
          Text(
            'ឈ្មោះ (Kh)',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _nameKmCtrl,
            decoration: _inputDecoration('ឈ្មោះជាភាសាខ្មែរ'),
          ),
        ],
      ),
    );
  }

  /// Tab 1 – contact info: phone, email, address, contact person.
  Widget _buildContactTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'លេខទូរស័ព្ទ *',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('+855 12 345 678'),
          ),
          const SizedBox(height: 10),

          Text(
            'អ៊ីម៉ែល',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('customer@email.com'),
          ),
          const SizedBox(height: 10),

          Text(
            'អាសយដ្ឌាន',
            style: GoogleFonts.khmer(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _addressCtrl,
            decoration: _inputDecoration('អាសយដ្ឋានអតិថិជន'),
          ),
          const SizedBox(height: 10),

          Text(
            'អ្នកទំនាក់ទំនង',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _contactPersonCtrl,
            decoration: _inputDecoration('ឈ្មោះអ្នកទំនាក់ទំនង'),
          ),
        ],
      ),
    );
  }

  /// Tab 2 – financial info: tax number, payment terms, notes.
  Widget _buildFinancialTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'លេខពន្ធ *',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _taxNumberCtrl,
            decoration: _inputDecoration('VAT/ Tax registration number'),
          ),
          const SizedBox(height: 10),

          Text(
            'លក្ខខណ្ឌទូទាត់',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _paymentTermsCtrl,
            decoration: _inputDecoration('e.g. Net 30, COD'),
          ),
          const SizedBox(height: 10),

          Text(
            'កំណត់ចំណាំ',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _notesCtrl,
            decoration: _inputDecoration('កំណត់ចំណាំ ឬមតិយោបល់បន្ថែម'),
          ),
        ],
      ),
    );
  }

  /// Tab 3 – credit info: credit limit, credit balance, credit hold toggle.
  Widget _buildCreditTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ដែនកំណត់ឥណទាន (\$)',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _creditLimitCtrl,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('1000'),
          ),
          const SizedBox(height: 10),

          Text(
            'សមតុល្យឥណទានបច្ចុប្បន្ន (\$)',
            style: GoogleFonts.khmer(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: _creditBalanceCtrl,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('0'),
          ),
          const SizedBox(height: 3),
          Text(
            'សមតុល្យ​ដែល​នៅ​សេសសល់​បច្ចុប្បន្ន',
            style: GoogleFonts.khmer(fontSize: 10),
          ),
          const SizedBox(height: 10),

          // Credit Hold toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credit Hold',
                      style: GoogleFonts.khmer(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Prevent new orders if enabled'),
                  ],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _creditHoldNotifier,
                  builder: (context, value, child) => Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: value,
                      onChanged: (v) => _creditHoldNotifier.value = v,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TabItem widget
// ─────────────────────────────────────────────────────────────────────────────

/// An animated pill-shaped tab chip used in the create-customer form tab bar.
class TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;

  const TabItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isActive ? Colors.white : Colors.black),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.khmer(
              fontSize: 12,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
