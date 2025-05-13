import 'package:angelina_app/features/payment/data/repo/paymob_repo.dart';
import 'package:angelina_app/features/payment/data/repo/user_info_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymobRepo paymobRepo;

  PaymentCubit(this.paymobRepo) : super(PaymentInitial());

  Future<void> startPayment(int totalPriceInCents) async {
    emit(PaymentLoading());
    try {
      // 1. Get Auth Token
      final token = await paymobRepo.getAuthToken();

      // 2. Create Order
      final orderId = await paymobRepo.createOrder(token, totalPriceInCents);

      // 3. Get Payment Key
      final paymentKey = await paymobRepo.getPaymentKey(
        token: token,
        orderId: orderId,
        amountCents: totalPriceInCents,
      );

      emit(PaymentSuccess(paymentKey));
    } catch (e) {
      if (e is PaymobException) {
        emit(PaymentError('Paymob Error: ${e.message}'));
      } else if (e is OrderRepoException) {
        emit(PaymentError('Order Error: ${e.message}'));
      } else {
        emit(PaymentError('Unknown Error: ${e.toString()}'));
      }
    }
  }
}
