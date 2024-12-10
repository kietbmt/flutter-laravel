import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/models/product_model.dart';
import 'package:shopping/repository/product_repository.dart';
import 'package:shopping/ui/product/product_detail_screen.dart';
import 'package:shopping/ui/cart/cart_screen.dart';
import 'package:shopping/ui/favorites/favorite_products_screen.dart';
import 'package:shopping/ui/profile/profile_screen.dart'; 
import 'package:shopping/ui/profile/edit_profile_screen.dart'; 
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final int selectedTab;
  const HomeScreen({Key? key, this.selectedTab = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPos = 0;
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<Product> featuredProducts = [];
  TextEditingController _searchController = TextEditingController();
  int _currentFeaturedIndex = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    currentPos = widget.selectedTab;
    fetchProducts();
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _stopCarouselTimer();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final String token = 'your_token_here';
      ProductRepository productRepository = ProductRepository();
      List<Product> productList = await productRepository.fetchProducts(token);

      // Identify featured products based on their IDs (e.g., IDs 1, 3, and 7 are featured)
      List<int> featuredIds = [1, 3, 7];
      List<Product> featuredProducts = productList.where((product) => featuredIds.contains(product.id)).toList();

      setState(() {
        products = productList;
        filteredProducts = productList;
        this.featuredProducts = featuredProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(10),
          ),
        );
      }
    }
  }

  void _searchProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        String normalizedTitle = normalizeString(product.title);
        String normalizedQuery = normalizeString(query);
        return normalizedTitle.contains(normalizedQuery);
      }).toList();
    });
  }

  String normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd');
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentFeaturedIndex = (_currentFeaturedIndex + 1) % featuredProducts.length;
      });
    });
  }

  void _stopCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Clothing Store',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.grey[700],
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product categories
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Browse Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    _CategoryButton(title: 'Shirts'),
                    const SizedBox(width: 12),
                    _CategoryButton(title: 'Pants'),
                    const SizedBox(width: 12),
                    _CategoryButton(title: 'Dresses'),
                    const SizedBox(width: 12),
                    _CategoryButton(title: 'Jackets'),
                    const SizedBox(width: 12),
                    _CategoryButton(title: 'Accessories'),
                  ],
                ),
              ],
            ),
          ),

          // Featured products carousel
          if (featuredProducts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: featuredProducts.length,
                      controller: PageController(
                        initialPage: _currentFeaturedIndex,
                      ),
                      onPageChanged: (index) {
                        setState(() {
                          _currentFeaturedIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final product = featuredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product.photo[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          featuredProducts.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: index == _currentFeaturedIndex
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Search and product grid
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchProducts,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetailScreen(product: product));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: product.photo.isNotEmpty
                                      ? Image.network(
                                          product.photo[0],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.error_outline),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Icon(Icons.image_not_supported),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPos,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        elevation: 6,
        onTap: (index) {
          setState(() {
            currentPos = index;
            switch (index) {
              case 1:
                Get.to(FavoriteProductsScreen());
                break;
              case 3:
                Get.to(() => ProfileScreen());
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(product: products[currentPos]),
                  ),
                );
                break;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String title;

  const _CategoryButton({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle category selection
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(title),
    );
  }
}