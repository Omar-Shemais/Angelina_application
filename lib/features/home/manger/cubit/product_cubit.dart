import 'dart:async';

import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/notification_utils/notification_utils.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  int _page = 1;
  final int _perPage = 10;
  bool _hasMore = true;
  final List<ProductModel> _allProducts = [];
  final bool _isLoaded = false;
  int? _currentCategoryId;

  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> fetchInitialProducts() async {
    if (_isLoaded) return;
    emit(ProductLoading());
    _page = 1;
    _hasMore = true;
    _allProducts.clear();
    await _fetchProducts();
  }

  Future<void> loadMoreProducts() async {
    if (_hasMore && state is ProductSuccess) {
      final currentState = state as ProductSuccess;
      emit(currentState.copyWith(isLoadingMore: true));

      _page++;
      try {
        final products =
            _currentCategoryId == null
                ? await repository.fetchProducts(page: _page, perPage: _perPage)
                : await repository.fetchProductsByCategory(
                  categoryId: _currentCategoryId!,
                  page: _page,
                  perPage: _perPage,
                );

        if (products.length < _perPage) _hasMore = false;

        _allProducts.addAll(products);
        emit(
          ProductSuccess(
            List<ProductModel>.from(_allProducts),
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await repository.fetchProducts(
        page: _page,
        perPage: _perPage,
      );
      if (products.length < _perPage) _hasMore = false;

      _allProducts.addAll(products);
      // atok Noficcation
      _checkStockNotifications(products);
      emit(
        ProductSuccess(
          List<ProductModel>.from(_allProducts),
          hasMore: _hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> fetchProductsForCategory(int categoryId) async {
    _currentCategoryId = categoryId;
    emit(ProductLoading());
    _page = 1;
    _hasMore = true;
    _allProducts.clear();
    try {
      final products = await repository.fetchProductsByCategory(
        categoryId: categoryId,
        page: _page,
        perPage: _perPage,
      );
      if (products.length < _perPage) _hasMore = false;

      _allProducts.addAll(products);

      emit(
        ProductSuccess(
          List<ProductModel>.from(_allProducts),
          hasMore: _hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(ProductLoading());
    try {
      final products = await repository.searchProducts(query);
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  // New notifaction
  Future<void> checkForNewProducts() async {
    try {
      final lastAttempt = await CachingUtils.getLastProductCheckAttemptTime();

      if (lastAttempt != null) {
        final now = DateTime.now();
        final diff = now.difference(lastAttempt);
        if (diff.inHours < 1) {
          print("Skip product check: Last attempt was less than 1 hour ago.");
          return;
        }
      }

      // Save current attempt time immediately
      await CachingUtils.saveLastProductCheckAttemptTime(DateTime.now());

      final lastChecked = await CachingUtils.getLastProductCheckAttemptTime();
      final products = await repository.fetchAllProducts();

      if (lastChecked == null) {
        final latestDate = _getLatestProductDate(products);
        if (latestDate != null) {
          await CachingUtils.saveLastProductCheckAttemptTime(latestDate);
        }
        return;
      }

      final newProducts =
          products.where((product) {
            final createdDate = DateTime.tryParse(product.dateCreated);
            return createdDate != null && createdDate.isAfter(lastChecked);
          }).toList();

      if (newProducts.isNotEmpty) {
        await NotificationService.showNotification(
          id: 9999,
          title: "منتجات جديدة 🎉",
          body: "تم إضافة منتجات جديدة، تفقدها الآن!",
        );

        final latestDate = _getLatestProductDate(products);
        if (latestDate != null) {
          await CachingUtils.saveLastProductCheckAttemptTime(latestDate);
        }
      }
    } catch (e) {
      print('Error checking for new products: $e');
    }
  }

  DateTime? _getLatestProductDate(List<ProductModel> products) {
    final dates =
        products
            .map((p) => DateTime.tryParse(p.dateCreated))
            .whereType<DateTime>()
            .toList();
    dates.sort(); // Ascending
    return dates.isNotEmpty ? dates.last : null;
  }

  // sale notifaction
  Future<void> checkForSales() async {
    try {
      final lastChecked = await CachingUtils.getLastSaleStockCheckTime();
      final now = DateTime.now();

      // Check if it's been at least 1 day since the last check
      if (lastChecked != null && now.difference(lastChecked).inHours < 1) {
        print("Skip sale check: Last attempt was less than 1 hour ago.");
        return;
      }

      // Save current time as the check time
      await CachingUtils.saveLastSaleStockCheckTime(now);

      final products = await repository.fetchAllProducts();
      final onSaleProducts =
          products
              .where(
                (p) => double.parse(p.salePrice) < double.parse(p.regularPrice),
              )
              .toList();

      if (onSaleProducts.isNotEmpty) {
        final saleProduct =
            onSaleProducts.first; // Notify about the first sale product
        print('checkForSales: $saleProduct');
        await NotificationService.showNotification(
          id: saleProduct.id,
          title: "خصم جديد! 🎉",
          body: "${saleProduct.name} الآن بسعر مخفض",
        );
      }
    } catch (e) {
      print('Error checking for sales: $e');
    }
  }

  // stock notifaction
  void _checkStockNotifications(List<ProductModel> products) async {
    try {
      final lastChecked = await CachingUtils.getLastSaleStockCheckTime();
      final now = DateTime.now();

      // Check if it's been at least 1 day since the last check
      if (lastChecked != null && now.difference(lastChecked).inHours < 1) {
        print("Skip stock check: Last attempt was less than 1 hour ago.");
        return;
      }

      // Save current time as the check time
      await CachingUtils.saveLastSaleStockCheckTime(now);

      final notifiedIds = await CachingUtils.getNotifiedLowStockProductIds();

      for (var product in products) {
        // Check for low stock notification (quantity <= 5)
        if (product.stockQuantity <= 5 && !notifiedIds.contains(product.id)) {
          print('_checkStockNotifications $product');
          await NotificationService.showNotification(
            id: 2000 + product.id,
            title: "الكمية على وشك النفاد!",
            body:
                "المنتج ${product.name} لم يتبق منه سوى ${product.stockQuantity} قطع.",
          );
          await CachingUtils.addNotifiedProductId(
            product.id,
          ); // Save ID to avoid re-notification
        }

        // Optional: Notify when a product is back in stock (quantity == 1)
        if (product.stockQuantity == 1) {
          await NotificationService.showNotification(
            id: 3000 + product.id, // Separate ID for back-in-stock
            title: "المنتج متوفر الآن 🎉",
            body:
                "المنتج ${product.name} عاد للتوفر، سارع بالطلب قبل نفاد الكمية!",
          );
        }
      }
    } catch (e) {
      print('Error checking for stock notifications: $e');
    }
  }
}
