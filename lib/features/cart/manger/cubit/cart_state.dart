import 'package:angelina_app/features/home/data/model/product_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartProductModel> items;

  CartLoaded(this.items);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}

// import 'package:angelina_app/features/home/data/model/product_model.dart';

// abstract class CartState {}

// class CartInitial extends CartState {}

// class CartLoading extends CartState {}

// class CartLoaded extends CartState {
//   final List<CartProductModel> items;
//   CartLoaded(this.items);
// }
