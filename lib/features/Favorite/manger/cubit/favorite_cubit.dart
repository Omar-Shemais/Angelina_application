import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/notification_utils/notification_utils.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  List<ProductModel> _favorites = [];
  List<ProductModel> _filteredFavorites = [];

  List<ProductModel> get favorites =>
      _filteredFavorites.isEmpty ? _favorites : _filteredFavorites;

  Future<void> loadFavorites() async {
    emit(FavoriteLoading());
    final rawItems = await CachingUtils.getFavoriteItems();
    _favorites = rawItems.map((e) => ProductModel.fromJson(e)).toList();
    _filteredFavorites = List.from(_favorites);
    emit(FavoriteLoaded(_favorites));
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final exists = _favorites.any((element) => element.id == product.id);

    if (exists) {
      _favorites.removeWhere((element) => element.id == product.id);
    } else {
      _favorites.add(product);
    }

    await CachingUtils.saveFavoriteItems(
      _favorites.map((e) => e.toJson()).toList(),
    );
    emit(FavoriteLoaded(_favorites));
  }

  bool isFavorite(ProductModel product) {
    return _favorites.any((element) => element.id == product.id);
  }

  Future<void> clearFavorite() async {
    await CachingUtils.clearFavorites();
    emit(FavoriteLoaded([]));
  }

  void searchFavorites(String query) {
    if (query.isEmpty) {
      _filteredFavorites = List.from(_favorites);
    } else {
      _filteredFavorites =
          _favorites
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    emit(FavoriteLoaded(_filteredFavorites));
  }

  Future<void> checkFavoriteNotifications() async {
    final notifiedProductIds = await CachingUtils.getNotifiedFavorites();
    final lastPrices = await CachingUtils.getLastFavoritePrices();

    for (final product in _favorites) {
      final currentPrice = double.tryParse(product.price) ?? 0.0;
      final lastPrice = lastPrices[product.id.toString()] ?? currentPrice;
      final isPriceDropped = currentPrice < lastPrice;
      final isLowStock = product.stockQuantity <= 5;

      if ((isPriceDropped || isLowStock) &&
          !notifiedProductIds.contains(product.id)) {
        final message =
            isPriceDropped
                ? 'سعر ${product.id} انخفض من ${lastPrice.toStringAsFixed(2)} إلى ${currentPrice.toStringAsFixed(2)}!'
                : '${product.id} اقترب من النفاد، سارع بشرائه الآن.';

        await NotificationService.showNotification(
          id: 2000 + product.id,
          title: 'تنبيه حول منتج مفضل',
          body: message,
        );

        notifiedProductIds.add(product.id);
      }

      lastPrices[product.id.toString()] = currentPrice;
    }

    await CachingUtils.saveNotifiedFavorites(notifiedProductIds);
    await CachingUtils.saveLastFavoritePrices(lastPrices);
  }
}
