// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:angelina_app/core/utils/notification_utils/notification_utils.dart';
// import 'package:angelina_app/features/home/data/model/product_model.dart';
// import 'package:angelina_app/features/home/data/repo/product_repo.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Keys for SharedPreferences
// const String LAST_PRICE_CHECK_KEY = "last_price_check";
// const String PRODUCT_PRICES_KEY = "product_prices";
// const String PRODUCT_STOCKS_KEY = "product_stocks";
// const String WISHLIST_PRODUCTS_KEY = "wishlist_products";
// const String CART_ABANDONED_KEY = "cart_abandoned_timestamp";

// class BackgroundTasksManager {
//   static final ProductRepository _repository = ProductRepository();

//   // Initialize background tasks
//   static Future<void> initialize() async {
//     // Initialize notification service
//     await NotificationService.initialize();
//     await requestNotificationPermission();

//     // Setup background tasks with workmanager
//     await NotificationService.setupBackgroundTasks();

//     // Run initial foreground checks
//     await checkForNewProducts();
//     await checkForPriceChanges();
//     await checkForStockChanges();
//     await checkForSpecialOffers();
//   }

//   // Check for new products (can be called from foreground or background)
//   static Future<void> checkForNewProducts() async {
//     await NotificationService.checkForNewProducts();
//   }

//   // Monitor price changes for previously viewed or wishlisted products
//   static Future<void> checkForPriceChanges() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final lastCheck = prefs.getInt(LAST_PRICE_CHECK_KEY) ?? 0;
//       final now = DateTime.now().millisecondsSinceEpoch;

//       // Only check once per day to avoid API overuse
//       if (now - lastCheck < Duration(hours: 24).inMilliseconds) {
//         return;
//       }

//       // Get stored product prices
//       final storedPricesStr = prefs.getString(PRODUCT_PRICES_KEY) ?? "{}";
//       Map<String, dynamic> storedPrices = Map<String, dynamic>.from(
//         jsonDecode(storedPricesStr),
//       );

//       // Get wishlisted products
//       final wishlistStr = prefs.getStringList(WISHLIST_PRODUCTS_KEY) ?? [];
//       final wishlistIds =
//           wishlistStr
//               .map((e) => int.tryParse(e) ?? 0)
//               .where((id) => id > 0)
//               .toList();

//       // Get viewed products
//       final viewedStr = prefs.getStringList(VIEWED_PRODUCTS_KEY) ?? [];
//       final viewedIds =
//           viewedStr
//               .map((e) => int.tryParse(e) ?? 0)
//               .where((id) => id > 0)
//               .toList();

//       // Combine both lists but prioritize wishlist
//       Set<int> productsToCheck = Set<int>.from(wishlistIds);
//       productsToCheck.addAll(viewedIds);

//       // Limit to 20 products to check
//       List<int> productIdsList = productsToCheck.toList();
//       if (productIdsList.length > 20) {
//         productIdsList = productIdsList.sublist(0, 20);
//       }

//       // Check each product for price changes
//       for (final productId in productIdsList) {
//         try {
//           final product = await _repository.fetchProductById(productId);
//           final currentPrice = double.tryParse(product.price) ?? 0;

//           // Check if we have stored price
//           if (storedPrices.containsKey(productId.toString())) {
//             final oldPrice =
//                 double.tryParse(
//                   storedPrices[productId.toString()].toString(),
//                 ) ??
//                 0;

//             // Check for price drop
//             if (oldPrice > currentPrice && currentPrice > 0) {
//               await NotificationService.sendPriceDropNotification(
//                 product,
//                 oldPrice,
//               );
//             }
//           }

//           // Update stored price
//           storedPrices[productId.toString()] = currentPrice.toString();
//         } catch (e) {
//           print('Error checking price for product $productId: $e');
//         }
//       }

//       // Save updated prices
//       await prefs.setString(PRODUCT_PRICES_KEY, jsonEncode(storedPrices));
//       await prefs.setInt(LAST_PRICE_CHECK_KEY, now);
//     } catch (e) {
//       print('Error in price change check: $e');
//     }
//   }

//   // Check for stock changes (important for out-of-stock products)
//   static Future<void> checkForStockChanges() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Get stored stock levels
//       final storedStocksStr = prefs.getString(PRODUCT_STOCKS_KEY) ?? "{}";
//       Map<String, dynamic> storedStocks = Map<String, dynamic>.from(
//         jsonDecode(storedStocksStr),
//       );

//       // Get wishlisted products (priority)
//       final wishlistStr = prefs.getStringList(WISHLIST_PRODUCTS_KEY) ?? [];
//       final wishlistIds =
//           wishlistStr
//               .map((e) => int.tryParse(e) ?? 0)
//               .where((id) => id > 0)
//               .toList();

//       // Check for stock changes in wishlist products
//       for (final productId in wishlistIds) {
//         try {
//           final product = await _repository.fetchProductById(productId);
//           final currentStock = product.stockQuantity ?? 0;

//           // Check if we have stored stock amount
//           if (storedStocks.containsKey(productId.toString())) {
//             final oldStock =
//                 int.tryParse(storedStocks[productId.toString()].toString()) ??
//                 0;

//             // If product was out of stock and now in stock
//             if (oldStock <= 0 && currentStock > 0) {
//               await NotificationService.sendRestockNotification(product);
//             }
//             // If product has limited stock remaining
//             else if (oldStock > 10 && currentStock <= 10 && currentStock > 0) {
//               await NotificationService.sendLimitedStockNotification(product);
//             }
//           }

//           // Update stored stock
//           storedStocks[productId.toString()] = currentStock.toString();
//         } catch (e) {
//           print('Error checking stock for product $productId: $e');
//         }
//       }

//       // Save updated stocks
//       await prefs.setString(PRODUCT_STOCKS_KEY, jsonEncode(storedStocks));
//     } catch (e) {
//       print('Error in stock change check: $e');
//     }
//   }

//   // Check for special offers or seasonal promotions
//   static Future<void> checkForSpecialOffers() async {
//     try {
//       // This would ideally connect to an API endpoint specifically for promotions
//       // For now, we'll simulate by looking for products with sale prices

//       final products = await _repository.fetchProducts(perPage: 20);

//       final salesProducts =
//           products
//               .where(
//                 (product) =>
//                     product.onSale == true &&
//                     product.salePrice != null &&
//                     product.salePrice!.isNotEmpty,
//               )
//               .toList();

//       if (salesProducts.isNotEmpty) {
//         // Pick a random sale product to feature
//         final random = Random();
//         final randomProduct =
//             salesProducts[random.nextInt(salesProducts.length)];

//         final regularPrice =
//             double.tryParse(randomProduct.regularPrice ?? "0") ?? 0;
//         final salePrice = double.tryParse(randomProduct.salePrice ?? "0") ?? 0;

//         if (salePrice > 0 && regularPrice > salePrice) {
//           final discount =
//               ((regularPrice - salePrice) / regularPrice * 100).round();

//           await NotificationService.showNotification(
//             id: 8000 + randomProduct.id,
//             title: "عرض خاص! 🔥",
//             body:
//                 "خصم $discount% على ${randomProduct.name}! السعر الآن $salePrice فقط",
//             payload: "sale_${randomProduct.id}",
//           );
//         }
//       }
//     } catch (e) {
//       print('Error checking special offers: $e');
//     }
//   }

//   // Check for abandoned cart and send reminder
//   static Future<void> checkForAbandonedCart(
//     Map<String, dynamic> cartItems,
//   ) async {
//     try {
//       if (cartItems.isNotEmpty) {
//         final prefs = await SharedPreferences.getInstance();
//         final lastAbandonedCheck = prefs.getInt(CART_ABANDONED_KEY) ?? 0;
//         final now = DateTime.now().millisecondsSinceEpoch;

//         // If cart has items and hasn't been checked in 6 hours
//         if (now - lastAbandonedCheck > Duration(hours: 6).inMilliseconds) {
//           // Get first item name
//           String itemName = "منتجات";
//           int itemCount = cartItems.length;

//           if (itemCount > 0) {
//             try {
//               final firstItemId = int.tryParse(cartItems.keys.first) ?? 0;
//               if (firstItemId > 0) {
//                 final product = await _repository.fetchProductById(firstItemId);
//                 itemName = product.name;
//               }
//             } catch (e) {
//               // Use default name if product fetch fails
//             }
//           }

//           // Send abandoned cart notification
//           await NotificationService.showNotification(
//             id: 9000,
//             title: "سلة المشتريات بانتظارك! 🛒",
//             body:
//                 "لديك $itemCount ${itemCount > 1 ? 'منتجات' : 'منتج'} في سلتك بما في ذلك $itemName",
//             payload: "cart",
//           );

//           // Update last check time
//           await prefs.setInt(CART_ABANDONED_KEY, now);
//         }
//       }
//     } catch (e) {
//       print('Error checking abandoned cart: $e');
//     }
//   }

//   // Track product price for future comparison
//   static Future<void> trackProductPrice(ProductModel product) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final storedPricesStr = prefs.getString(PRODUCT_PRICES_KEY) ?? "{}";

//       Map<String, dynamic> storedPrices = Map<String, dynamic>.from(
//         jsonDecode(storedPricesStr),
//       );

//       // Store current price
//       storedPrices[product.id.toString()] = product.price;

//       await prefs.setString(PRODUCT_PRICES_KEY, jsonEncode(storedPrices));
//     } catch (e) {
//       print('Error tracking product price: $e');
//     }
//   }

//   // Track product stock for future comparison
//   static Future<void> trackProductStock(ProductModel product) async {
//     try {
//       if (product.stockQuantity != null) {
//         final prefs = await SharedPreferences.getInstance();
//         final storedStocksStr = prefs.getString(PRODUCT_STOCKS_KEY) ?? "{}";

//         Map<String, dynamic> storedStocks = Map<String, dynamic>.from(
//           jsonDecode(storedStocksStr),
//         );

//         // Store current stock
//         storedStocks[product.id.toString()] = product.stockQuantity.toString();

//         await prefs.setString(PRODUCT_STOCKS_KEY, jsonEncode(storedStocks));
//       }
//     } catch (e) {
//       print('Error tracking product stock: $e');
//     }
//   }

//   // Add product to wishlist tracking
//   static Future<void> addToWishlistTracking(int productId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final wishlistStr = prefs.getStringList(WISHLIST_PRODUCTS_KEY) ?? [];

//       Set<String> wishlistSet = wishlistStr.toSet();
//       wishlistSet.add(productId.toString());

//       await prefs.setStringList(WISHLIST_PRODUCTS_KEY, wishlistSet.toList());

//       // Also fetch and track this product's details
//       try {
//         final product = await _repository.fetchProductById(productId);
//         await trackProductPrice(product);
//         await trackProductStock(product);
//       } catch (e) {
//         print('Error fetching wishlist product: $e');
//       }
//     } catch (e) {
//       print('Error adding to wishlist tracking: $e');
//     }
//   }

//   // Remove product from wishlist tracking
//   static Future<void> removeFromWishlistTracking(int productId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final wishlistStr = prefs.getStringList(WISHLIST_PRODUCTS_KEY) ?? [];

//       List<String> wishlist =
//           wishlistStr.where((id) => id != productId.toString()).toList();

//       await prefs.setStringList(WISHLIST_PRODUCTS_KEY, wishlist);
//     } catch (e) {
//       print('Error removing from wishlist tracking: $e');
//     }
//   }
// }
// import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:angelina_app/features/home/data/repo/product_repo.dart';
// import 'package:angelina_app/core/utils/notification_utils/notification_utils.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await NotificationService.init(); // Ensure notifications are initialized

//     final repo = ProductRepository();
//     final products = await repo.fetchProducts(perPage: 1);
//     final latestProduct = products.first;

//     // Sample local logic: store latest product id in SharedPreferences
//     // You can use a caching util similar to your existing ones
//     final lastSeenId = await CachingUtils.getLatestProductId();

//     if (latestProduct.id != lastSeenId) {
//       NotificationService.showNotification(
//         id: latestProduct.id,
//         title: '🎉 منتج جديد!',
//         body: latestProduct.name,
//       );
//       await CachingUtils.saveLatestProductId(latestProduct.id);
//     }

//     return Future.value(true);
//   });
// }
