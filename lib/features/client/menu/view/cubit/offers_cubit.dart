import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/model/offers_model.dart';
import 'package:embone/features/client/menu/data/repo/offer_repo.dart';
import 'package:embone/features/client/menu/view/cubit/offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final OfferRepo offerRepo;
  List<Offer> offers = [];
  int currentPage = 1;
  int limit = 4;
  bool hasMoreOffers = true;
  bool isLoadingMore = false;

  OffersCubit(this.offerRepo) : super(OffersInitial());

  void init() {
    fetchOffers();
  }

  Future<void> fetchOffers({bool loadMore = false}) async {
    if (isClosed) return;

    if (loadMore && !hasMoreOffers) {
      return;
    }

    if (loadMore) {
      isLoadingMore = true;
      emit(OfferLoadingMore());
      currentPage++;
    } else {
      emit(OfferLoading());
      currentPage = 1;
      offers = [];
    }

    Print.info("Starting to fetch offers, page: $currentPage");

    final result = await offerRepo.fetchOffers(page: currentPage, limit: limit);

    if (isClosed) return;

    result.fold(
      (error) {
        Print.error("Failed to fetch offers: $error");
        emit(OfferError(error));
      },
      (offerModel) {
        offers.addAll(offerModel.data!.offers ?? []);
        hasMoreOffers = offerModel.data?.offers?.length == limit;
        Print.info("Fetched ${offers.length} offers successfully");
        emit(OfferLoaded(offerModel));
      },
    );
  }
}
