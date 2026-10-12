import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/order_service.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/loading_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  Future<void> _checkout() async {
    setState(() => _isCheckingOut = true);

    try {
      final orders = await OrderService().checkout();
      if (!mounted) {
        return;
      }

      if (orders.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Checkout completed.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout created ${orders.length} order(s).'),
          ),
        );
      }

      await context.read<CartProvider>().loadCart();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    if (cartProvider.isLoading) {
      return const Scaffold(body: LoadingView(message: 'Loading your cart...'));
    }

    if (cartProvider.items.isEmpty) {
      return const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SizedBox(),
        ),
        body: EmptyStateView(
          title: 'Your cart is empty',
          subtitle: 'Add a product to start shopping.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                final product = item.product;

                if (product == null) {
                  return const SizedBox.shrink();
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text('£${product.price.toStringAsFixed(2)} each'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: item.quantity > 1
                                        ? () => context
                                              .read<CartProvider>()
                                              .updateQuantity(
                                                item.id,
                                                item.quantity - 1,
                                              )
                                        : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text('${item.quantity}'),
                                  IconButton(
                                    onPressed: () => context
                                        .read<CartProvider>()
                                        .updateQuantity(
                                          item.id,
                                          item.quantity + 1,
                                        ),
                                    icon: const Icon(Icons.add),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '£${item.subtotal.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.read<CartProvider>().removeItem(item.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('£${cartProvider.subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _isCheckingOut ? null : _checkout,
                    child: _isCheckingOut
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Proceed to checkout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
