import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/sale_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/sale_service.dart';
import 'package:test_responsive/util/base_url.dart';
import 'package:test_responsive/screen/invoice/invoice_screen.dart';

class InviceHistoryScreen extends StatefulWidget {
  const InviceHistoryScreen({super.key});

  @override
  State<InviceHistoryScreen> createState() => _InviceHistoryScreenState();
}

class _InviceHistoryScreenState extends State<InviceHistoryScreen> {
  final SaleService _saleService = SaleService(
    apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
  );
  List<SaleModel> _sales = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await StorageService.getToken();
      final sales = await _saleService.listSales(token: token, status: 'PAID');
      setState(() => _sales = sales);
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ប្រវត្តិវិក្កយប័ត្រ',
          style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchInvoices,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchInvoices,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          _buildInfoInvoice(theme),
                          const SizedBox(height: 20),
                          _buildListInvoice(theme),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoInvoice(ThemeData theme) {
    final totalRevenue = _sales.fold<double>(
      0,
      (sum, sale) => sum + sale.grandTotal,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ចំនួនប្រតិបត្តិការ',
                      style: GoogleFonts.khmer(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: const Color(0xFF89C9FD),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_sales.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: const Icon(Icons.book_rounded, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, height: 1, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'ប្រាក់ចំណូលសរុប',
              style: GoogleFonts.khmer(fontSize: 14, color: Colors.white60),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${totalRevenue.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListInvoice(ThemeData theme) {
    if (_sales.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'មិនមានវិក្កយបត្រ',
            style: GoogleFonts.khmer(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _sales.length,
      itemBuilder: (context, index) {
        final sale = _sales[index];
        return _buildInvoiceCard(sale, theme);
      },
    );
  }

  Widget _buildInvoiceCard(SaleModel sale, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.book_rounded,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        sale.invoiceNumber ?? '#${sale.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${sale.grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (sale.customerName != null) ...[
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          sale.customerName!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sale.createdAt ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '${sale.lines.length} items',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        maximumSize: const Size.fromHeight(60),
                        backgroundColor: Colors.blue.shade800,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceScreen(sale: sale),
                          ),
                        );
                      },
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'View',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      icon: const Icon(Icons.book_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
