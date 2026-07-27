part of 'payment_cubit.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.loading() = _Loading;
  const factory PaymentState.loaded(
    List<PaymentModel> payments,
    int currentPage,
    int totalPages,
  ) = _Loaded;
  const factory PaymentState.error(String message) = _Error;
}
