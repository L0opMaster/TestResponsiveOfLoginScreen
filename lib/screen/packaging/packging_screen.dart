import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/model/sale_model.dart';
import 'package:test_responsive/provider/packaging_provider.dart';
import 'package:test_responsive/screen/invoice/invoice_history_screen.dart';

class PackgingScreen extends StatefulWidget {
  const PackgingScreen({super.key});

  @override
  State<PackgingScreen> createState() => _PackgingScreenState();
}

class _PackgingScreenState extends State<PackgingScreen> {
  String _selectedFilter = 'ទាំងអស់';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackagingProvider>().fetchSales();
    });
  }

  void _onFilterTap(String label, String status) {
    setState(() => _selectedFilter = label);
    context.read<PackagingProvider>().setFilter(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopContent(),
              _buildCategory(),
              const SizedBox(height: 15),
              _buildListOrder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            'បញ្ចីវេចខ្ចប់',
            style: GoogleFonts.khmer(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return SizedBox(
      child: Row(
        children: [
          _categoryButton('ទាំងអស់', ''),
          _categoryButton('រង់ចាំ', 'PACKAGING'),
          _categoryButton('កំពុងរៀបចំ', 'PREPARING'),
        ],
      ),
    );
  }

  Widget _buildListOrder() {
    return Expanded(
      child: Consumer<PackagingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => provider.fetchSales(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.sales.isEmpty) {
            return Center(
              child: Text(
                'មិនមានការបញ្ជាទិញ',
                style: GoogleFonts.khmer(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchSales(),
            child: ListView.builder(
              itemCount: provider.sales.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(provider.sales[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(SaleModel sale) {
    final statusLabel = _statusLabel(sale.status);
    final statusColor = _statusColor(sale.status);
    final statusIcon = _statusIcon(sale.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sale.invoiceNumber ?? '#${sale.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: statusColor.withValues(alpha: 0.1),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, color: statusColor, size: 15),
                            const SizedBox(width: 10),
                            Text(
                              statusLabel,
                              style: GoogleFonts.khmer(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black54,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        sale.createdAt ?? '',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 15),
                      const SizedBox(width: 10),
                      Text(sale.customerName ?? sale.cashierName ?? ''),
                    ],
                  ),
                ],
              ),
            ),

            // Product lines + total
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                border: Border(
                  top: BorderSide(width: 0.9, color: Theme.of(context).dividerColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...sale.lines.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${line.productNameKm ?? line.productNameEn ?? ''} x${line.quantity.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Text(
                              '\$ ${line.lineTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
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
                          '\$ ${sale.grandTotal.toStringAsFixed(2)}',
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

            // Action buttons based on status
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildActionButtons(sale),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(SaleModel sale) {
    if (sale.status == 'PACKAGING') {
      // New order — employee can click Hold to claim it
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => _onHold(sale.id),
          label: Text(
            'កំពុងរៀបចំ',
            style: GoogleFonts.khmer(fontSize: 14, color: Colors.white),
          ),
          icon: const Icon(Icons.back_hand_outlined, color: Colors.white),
        ),
      );
    } else if (sale.status == 'PREPARING') {
      // Employee is preparing — can click Complete when done
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => _onComplete(sale.id),
          label: Text(
            'រួចរាល់',
            style: GoogleFonts.khmer(fontSize: 14, color: Colors.white),
          ),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _onHold(int saleId) async {
    final provider = context.read<PackagingProvider>();
    final success = await provider.startPreparing(saleId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('កំពុងរៀបចំការបញ្ជាទិញ', style: GoogleFonts.khmer()),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onComplete(int saleId) async {
    final provider = context.read<PackagingProvider>();
    final sale = await provider.completePackaging(saleId);
    if (!mounted) return;
    if (sale != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('វេចខ្ចប់រួចរាល់', style: GoogleFonts.khmer()),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InviceHistoryScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'PACKAGING':
        return 'រង់ចាំ';
      case 'PREPARING':
        return 'កំពុងរៀបចំ';
      case 'PAID':
        return 'បានបង់ប្រាក់';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PACKAGING':
        return Colors.blue.shade800;
      case 'PREPARING':
        return Colors.orange.shade800;
      case 'PAID':
        return Colors.green.shade800;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'PACKAGING':
        return Icons.hourglass_empty;
      case 'PREPARING':
        return Icons.timer_outlined;
      case 'PAID':
        return Icons.check_circle_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _categoryButton(String title, String status) {
    final isSelected = _selectedFilter == title;
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () => _onFilterTap(title, status),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            border: Border.all(
              width: 1,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(
              title,
              style: GoogleFonts.khmer(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
