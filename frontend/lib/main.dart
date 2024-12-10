// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/home/home_screen.dart';  // Import HomeScreen đúng cách
import 'views/login.dart';
import 'views/register.dart';
import 'ui/checkout/checkout_address.dart';
import 'ui/checkout/checkout_confirm.dart';
import 'ui/checkout/checkout_payment.dart';
import 'package:shopping/ui/profile/profile_screen.dart'; 
import 'package:shopping/ui/profile/edit_profile_screen.dart'; 
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp())); // Khởi chạy ứng dụng với Riverpod
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(),
      initialRoute: '/login', // Trang khởi đầu là login
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/checkout_address', page: () => CheckoutAddressScreen()),
        GetPage(name: '/checkout_confirm', page: () => CheckoutConfirmScreen()),
        GetPage(name: '/checkout_payment', page: () => CheckoutPaymentScreen()), 
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/edit-profile', page: () => EditProfileScreen()),

      ],
    );
  }
}
