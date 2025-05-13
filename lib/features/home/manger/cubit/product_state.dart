part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

// class ProductSuccess extends ProductState {
//   final List<ProductModel> products;

//   ProductSuccess(this.products);
// }
class ProductSuccess extends ProductState {
  final List<ProductModel> products;
  final bool hasMore;
  final bool isLoadingMore;

  ProductSuccess(
    this.products, {
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ProductSuccess copyWith({
    List<ProductModel>? products,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductSuccess(
      products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductFailure extends ProductState {
  final String error;

  ProductFailure(this.error);
}
