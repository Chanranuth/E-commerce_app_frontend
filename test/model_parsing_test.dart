import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/user.dart';

void main() {
  group('Model parsing', () {
    test('AppUser parses a Laravel user payload', () {
      final user = AppUser.fromJson({
        'id': 9,
        'name': 'Alex Buyer',
        'email': 'alex@example.com',
        'role': 'CUSTOMER',
      });

      expect(user.id, 9);
      expect(user.name, 'Alex Buyer');
      expect(user.role, 'CUSTOMER');
    });

    test('Product parses a Laravel product payload', () {
      final product = Product.fromJson({
        'id': 4,
        'seller_id': 2,
        'category_id': 1,
        'name': 'Wireless Mouse',
        'sku': 'WM-100',
        'description': 'Ergonomic business mouse',
        'price': 26.5,
        'stock': 10,
        'is_active': true,
      });

      expect(product.name, 'Wireless Mouse');
      expect(product.stock, 10);
      expect(product.price, 26.5);
    });

    test('Product parses a decimal price returned as a string', () {
      final product = Product.fromJson({
        'id': 4,
        'seller_id': 2,
        'category_id': 1,
        'name': 'Wireless Mouse',
        'sku': 'WM-100',
        'description': 'Ergonomic business mouse',
        'price': '26.50',
        'stock': 10,
        'is_active': true,
      });

      expect(product.price, 26.5);
    });

    test('Order parses nested items from checkout payload', () {
      final order = Order.fromJson({
        'id': 12,
        'customer_id': 4,
        'seller_id': 2,
        'total_amount': '42.00',
        'status': 'PENDING',
        'items': [
          {
            'id': 1,
            'product_id': 4,
            'product_name': 'Wireless Mouse',
            'sku': 'WM-100',
            'price': '21.00',
            'quantity': 2,
            'subtotal': '42.00',
          },
        ],
      });

      expect(order.status, 'PENDING');
      expect(order.items.length, 1);
      expect(order.items.first.productName, 'Wireless Mouse');
      expect(order.totalAmount, 42.0);
      expect(order.items.first.price, 21.0);
      expect(order.items.first.subtotal, 42.0);
    });
  });
}
