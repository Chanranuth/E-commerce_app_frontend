import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _cancelOrder() async {
    setState(() => _isUpdating = true);

    try {
      final updatedOrder = await OrderService().updateStatus(
        _order.id,
        'CANCELLED',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _order = updatedOrder;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order cancelled.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCancel = _order.status == 'PENDING' || _order.status == 'PAID';

    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Order #${_order.id}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Status: ${_order.status}'),
          const SizedBox(height: 16),
          const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._order.items.map(
            (item) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text('Qty: ${item.quantity}'),
                          Text('Unit: £${item.price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    Text('£${item.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('£${_order.totalAmount.toStringAsFixed(2)}'),
            ],
          ),
          if (canCancel) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isUpdating ? null : _cancelOrder,
              icon: const Icon(Icons.cancel_outlined),
              label: _isUpdating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cancel order'),
            ),
          ],
        ],
      ),
    );
  }
}
