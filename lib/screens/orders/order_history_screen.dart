import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Order> _orders = const [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final orders = await _orderService.fetchOrders();
      if (!mounted) {
        return;
      }
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingView(message: 'Loading orders...'));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My orders')),
        body: ErrorView(message: _errorMessage!, onRetry: _loadOrders),
      );
    }

    if (_orders.isEmpty) {
      return const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SizedBox(),
        ),
        body: EmptyStateView(
          title: 'No orders yet',
          subtitle: 'Your order history will appear here after checkout.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = _orders[index];
            return Card(
              child: ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seller: ${order.sellerName ?? 'Seller'}'),
                    const SizedBox(height: 4),
                    Text('Status: ${order.status}'),
                    const SizedBox(height: 4),
                    Text('Items: ${order.items.length}'),
                  ],
                ),
                trailing: Text('£${order.totalAmount.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailScreen(order: order),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
