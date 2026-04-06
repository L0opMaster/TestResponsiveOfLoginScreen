import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/sale_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/sale_service.dart';
import 'package:test_responsive/util/base_url.dart';

class InvoiceScreen extends StatelessWidget {
  final SaleModel sale;

  const InvoiceScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'វិក្កយបត្រ',
          style: GoogleFonts.khmer(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              _buildInvoice(context, theme),
              _buildPrintAndShareButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoice(BuildContext context, ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildTopIntroduceInvoice(),
          _buildTopContentInvoice(theme),
          if (sale.customerName != null) _buildCustomerDetails(theme),
          _buildItems(theme),
          _buildTotal(theme),
          _buildThankYou(theme),
        ],
      ),
    );
  }

  Widget _buildTopIntroduceInvoice() {
    return Container(
      decoration: BoxDecoration(color: Colors.lightGreen.shade700),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ការបញ្ជាទិញបានបញ្ចប់',
                  style: GoogleFonts.khmer(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'វិក្កយបត្រ​ត្រូវ​បាន​បង្កើត​ដោយ​ជោគជ័យ',
                  style: GoogleFonts.khmer(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContentInvoice(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  'KAKNNEA POS ORDER Packaging',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'KAKNNEA POS',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('លេខវិក្កយបត្រ', style: GoogleFonts.khmer(fontSize: 12)),
                Text(
                  sale.invoiceNumber ?? '#${sale.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('កាលបរិច្ឆេត', style: GoogleFonts.khmer(fontSize: 12)),
                Text(
                  sale.createdAt ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            if (sale.cashierName != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('អ្នកគិតលុយ', style: GoogleFonts.khmer(fontSize: 12)),
                  Text(
                    sale.cashierName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetails(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(width: 0.2, color: theme.dividerColor),
          bottom: BorderSide(width: 0.2, color: theme.dividerColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ព័ត៌មានលម្អិតរបស់អតិថិជន',
              style: GoogleFonts.khmer(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(sale.customerName ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildItems(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'របស់របរ',
              style: GoogleFonts.khmer(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...sale.lines.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final line = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('$index.'),
                            const SizedBox(width: 5),
                            Text(
                              line.productNameKm ?? line.productNameEn ?? '',
                            ),
                          ],
                        ),
                        Text(
                          '\$${line.lineTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${line.unitPrice.toStringAsFixed(2)} x ${line.quantity.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(width: 0.2, color: theme.dividerColor),
          bottom: BorderSide(width: 0.2, color: theme.dividerColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('តម្លៃរង', style: GoogleFonts.khmer(fontSize: 15)),
                Text(
                  '\$${sale.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (sale.discountAmount > 0) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('បញ្ចុះតម្លៃ', style: GoogleFonts.khmer(fontSize: 15)),
                  Text(
                    '-\$${sale.discountAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ពន្ធ (${(sale.taxRate * 100).toStringAsFixed(0)}%)',
                  style: GoogleFonts.khmer(fontSize: 15),
                ),
                Text(
                  '\$${sale.taxAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'សរុប',
                  style: GoogleFonts.khmer(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${sale.grandTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYou(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.04),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                'សូមអរគុណចំពោះអាជីវកម្មរបស់អ្នក!',
                style: GoogleFonts.khmer(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'នេះ​ជា​វិក្កយបត្រ​ដែល​បង្កើត​ដោយ​ស្វ័យប្រវត្តិ',
                style: GoogleFonts.khmer(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _printInvoice(BuildContext context) async {
    try {
      final saleService = SaleService(
        apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
      );
      final token = await StorageService.getToken();
      final pdfBytes = await saleService.getInvoicePdf(
        token: token,
        id: sale.id,
      );
      await Printing.layoutPdf(
        onLayout: (_) => Uint8List.fromList(pdfBytes),
        name: 'Invoice_${sale.invoiceNumber ?? sale.id}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Print failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareInvoice(BuildContext context) async {
    try {
      final saleService = SaleService(
        apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
      );
      final token = await StorageService.getToken();
      final pdfBytes = await saleService.getInvoicePdf(
        token: token,
        id: sale.id,
      );
      await Printing.sharePdf(
        bytes: Uint8List.fromList(pdfBytes),
        filename: 'Invoice_${sale.invoiceNumber ?? sale.id}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPrintAndShareButton(ThemeData theme) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _printInvoice(context),
                label: Text(
                  'Print',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                icon: Icon(
                  Icons.print_rounded,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _shareInvoice(context),
                label: Text(
                  'ចែករំលែក',
                  style: GoogleFonts.khmer(fontSize: 15, color: Colors.white),
                ),
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
