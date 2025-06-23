import 'package:embone/features/client/menu/data/model/faq_model.dart';

class FaqsState {
  const FaqsState();
}

final class FaqsInitial extends FaqsState {}

class FaqLoading extends FaqsState {}

class FaqLoaded extends FaqsState {
  final FaqResponseModel faqResponse;

  const FaqLoaded(this.faqResponse);
}

class FaqError extends FaqsState {
  final String message;

  const FaqError(this.message);
}
