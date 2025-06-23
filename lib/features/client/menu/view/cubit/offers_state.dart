import 'package:embone/features/client/menu/data/model/offers_model.dart';

class OffersState {}

final class OffersInitial extends OffersState {}

class OfferLoading extends OffersState {}

class OfferLoaded extends OffersState {
  final OfferModel offerModel;

  OfferLoaded(this.offerModel);
}

class OfferError extends OffersState {
  final String message;

  OfferError(this.message);
}

class OfferLoadingMore extends OffersState {}
