part of 'payment_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentKey;
  PaymentSuccess(this.paymentKey);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}
