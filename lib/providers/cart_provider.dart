import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  bool _isLoading = false;
  bool _isRefreshing = false;
  List<CartItem> _items = const [];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  List<CartItem> get items => _items;

  double get subtotal {
    var total = 0.0;
    for (final item in _items) {
      total += item.subtotal;
    }
    return total;
  }

  int get itemCount {
    var count = 0;
    for (final item in _items) {
      count += item.quantity;
    }
    return count;
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _cartService.fetchCartItems();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    _isRefreshing = true;
    notifyListeners();

    try {
      await _cartService.addItem(productId: productId, quantity: quantity);
      await loadCart();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    _isRefreshing = true;
    notifyListeners();

    try {
      await _cartService.updateQuantity(itemId, quantity);
      await loadCart();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> removeItem(int itemId) async {
    _isRefreshing = true;
    notifyListeners();

    try {
      await _cartService.removeItem(itemId);
      await loadCart();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }
}
