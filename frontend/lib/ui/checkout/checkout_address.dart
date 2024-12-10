// checkout_address.dart
import 'package:flutter/material.dart';

class CheckoutAddressScreen extends StatefulWidget {
  const CheckoutAddressScreen({Key? key}) : super(key: key);

  @override
  _CheckoutAddressScreenState createState() => _CheckoutAddressScreenState();
}

class _CheckoutAddressScreenState extends State<CheckoutAddressScreen> {
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_addressController.text.isNotEmpty) {
                  Navigator.pushNamed(context, '/checkout_confirm');
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
