// lib/ui/checkout/checkout_payment.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart'; // Thêm GetX để điều hướng

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({Key? key}) : super(key: key);

  @override
  _CheckoutPaymentScreenState createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String _paymentMethod = 'Credit Card';
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shippingAddressController = TextEditingController();

  // Hàm xác nhận đơn hàng
  void _confirmOrder() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String shippingAddress = _shippingAddressController.text;

    double totalAmount = 100.0; // Tổng giá trị đơn hàng
    List<Map<String, dynamic>> cartItems = [
      {'id': 1, 'quantity': 2},
      {'id': 2, 'quantity': 1},
    ];

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/order'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'phone': phone,
          'shipping_address': shippingAddress,
          'payment_method': _paymentMethod,
          'total_amount': totalAmount,
          'cart': cartItems,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Confirmed!')),
        );
        Get.toNamed('/checkout_confirm'); // Điều hướng đến màn hình xác nhận đơn hàng
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm order: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Các trường nhập liệu
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _shippingAddressController,
              decoration: const InputDecoration(labelText: 'Shipping Address'),
            ),
            const SizedBox(height: 20),
            const Text('Select your payment method:'),
            DropdownButton<String>(
              value: _paymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _paymentMethod = newValue!;
                });
              },
              items: <String>['Credit Card', 'PayPal', 'Cash on Delivery']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmOrder,
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
