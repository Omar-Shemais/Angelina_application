import 'dart:async';
import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/notification_utils/notification_utils.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  double _discountPercent = 0;

  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final rawItems = await CachingUtils.getCartItems();
      final products =
          rawItems.map((e) => CartProductModel.fromJson(e)).toList();
      emit(CartLoaded(products));
    } catch (e) {
      emit(CartError('فشل تحميل السلة'));
    }
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    if (state is CartLoaded) {
      final currentItems = List<CartProductModel>.from(
        (state as CartLoaded).items,
      );
      final index = currentItems.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        final updated = currentItems[index].copyWith(
          quantity: currentItems[index].quantity + quantity,
        );
        currentItems[index] = updated;
      } else {
        currentItems.add(
          CartProductModel(
            id: product.id,
            name: product.name,
            price: product.price,
            imageUrls: product.imageUrls,
            categories: product.categories,
            categoryIds: product.categoryIds,
            quantity: quantity,
          ),
        );
      }

      await CachingUtils.saveCartItems(
        currentItems.map((e) => e.toJson()).toList(),
      );
      emit(CartLoaded(currentItems));
    }
  }

  Future<void> removeFromCart(CartProductModel product) async {
    if (state is CartLoaded) {
      final updated = List<CartProductModel>.from((state as CartLoaded).items)
        ..removeWhere((p) => p.id == product.id);
      await CachingUtils.saveCartItems(updated.map((e) => e.toJson()).toList());
      emit(CartLoaded(updated));
    }
  }

  Future<void> clearCart() async {
    await CachingUtils.clearCart();
    emit(CartLoaded([]));
  }

  void increaseQuantity(int productId) {
    if (state is CartLoaded) {
      final items = List<CartProductModel>.from((state as CartLoaded).items);
      final index = items.indexWhere((item) => item.id == productId);
      if (index != -1) {
        items[index] = items[index].copyWith(
          quantity: items[index].quantity + 1,
        );
        CachingUtils.saveCartItems(items.map((e) => e.toJson()).toList());
        emit(CartLoaded(items));
      }
    }
  }

  void decreaseQuantity(int productId) {
    if (state is CartLoaded) {
      final items = List<CartProductModel>.from((state as CartLoaded).items);
      final index = items.indexWhere((item) => item.id == productId);
      if (index != -1 && items[index].quantity > 1) {
        items[index] = items[index].copyWith(
          quantity: items[index].quantity - 1,
        );
        CachingUtils.saveCartItems(items.map((e) => e.toJson()).toList());
        emit(CartLoaded(items));
      }
    }
  }

  void setDiscountPercent(double percent) {
    _discountPercent = percent;
    if (state is CartLoaded) {
      emit(
        CartLoaded(List<CartProductModel>.from((state as CartLoaded).items)),
      );
    }
  }

  double getDiscountPercent() => _discountPercent;

  double getTotalPrice() {
    if (state is CartLoaded) {
      return (state as CartLoaded).items.fold(
        0.0,
        (sum, p) => sum + (double.tryParse(p.price) ?? 0.0) * p.quantity,
      );
    }
    return 0.0;
  }

  double getDiscountAmount() => getTotalPrice() * (_discountPercent / 100);

  double getFinalTotal() => getTotalPrice() - getDiscountAmount();

  bool isInCart(int productId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      return currentState.items.any((item) => item.id == productId);
    }
    return false;
  }

  bool isProductInCartById(int productId) {
    if (state is CartLoaded) {
      final cartItems = (state as CartLoaded).items;
      return cartItems.any((item) => item.id == productId);
    }
    return false;
  }

  void refreshCartState() {
    if (state is CartLoaded) {
      // Force a state refresh without changing the items
      final currentItems = (state as CartLoaded).items;
      emit(CartLoaded(List.from(currentItems)));
    }
  }

  void removeItemByProductId(int productId) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedItems =
          currentState.items.where((item) => item.id != productId).toList();

      emit(CartLoaded(updatedItems));
    }
  }

  // notifecations

  Future<void> checkForAbandonedCarts() async {
    try {
      if (state is CartLoaded) {
        final cartItems = (state as CartLoaded).items;

        if (cartItems.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();

          // Check when the last notification was shown
          final lastShown = prefs.getInt('last_cart_notification_time') ?? 0;
          final now = DateTime.now().millisecondsSinceEpoch;

          // Show notification only if 24 hours (86400000 ms) have passed
          if (now - lastShown >= 86400000) {
            String productNames = cartItems.map((item) => item.name).join(", ");

            NotificationService.showNotification(
              id: 1001,
              title: "لا تفوت فرصة إتمام طلبك 🛒",
              body:
                  "لديك المنتجات التالية في عربة التسوق لم تكمل طلبك: $productNames. هل ترغب في إتمامه؟",
            );

            // Save the current time as the last shown time
            await prefs.setInt('last_cart_notification_time', now);
          }
        }
      }
    } catch (e) {
      print('Error checking for abandoned carts: $e');
    }
  }

  void startCheckingForAbandonedCarts() {
    checkForAbandonedCarts();
    Timer.periodic(const Duration(days: 1), (timer) {
      checkForAbandonedCarts();
    });
  }
}
