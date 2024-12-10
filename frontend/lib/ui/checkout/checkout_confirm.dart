// checkout_confirm.dart
import 'package:flutter/material.dart';

class CheckoutConfirmScreen extends StatelessWidget {
  const CheckoutConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Your Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Please review your order and address before proceeding to payment.'),
            // Add list of cart items here
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/checkout_payment');
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
