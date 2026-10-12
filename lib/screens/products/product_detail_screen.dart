import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../services/category_service.dart';
import '../../widgets/loading_view.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CategoryService _categoryService = CategoryService();
  List<CategoryModel> _categories = const [];
  bool _isLoadingCategory = true;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    try {
      final categories = await _categoryService.fetchCategories();
      if (!mounted) {
        return;
      }
      setState(() {
        _categories = categories;
        _isLoadingCategory = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoadingCategory = false);
    }
  }

  String get _categoryName {
    final category = _categories.firstWhere(
      (item) => item.id == widget.product.categoryId,
      orElse: () => CategoryModel(id: 0, name: 'Uncategorized'),
    );
    return category.name;
  }

  Future<void> _addToCart() async {
    try {
      await context.read<CartProvider>().addToCart(
        productId: widget.product.id,
        quantity: 1,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product added to cart')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '£${widget.product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoadingCategory)
              const LoadingView(message: 'Loading category...')
            else
              Chip(label: Text(_categoryName)),
            const SizedBox(height: 12),
            Text(
              'Stock available: ${widget.product.stock}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              widget.product.description.isEmpty
                  ? 'No description available.'
                  : widget.product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.product.stock > 0 ? _addToCart : null,
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: const Text('Add to cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
