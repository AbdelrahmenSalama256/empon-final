import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/model/faq_model.dart';
import 'package:embone/features/client/menu/data/repo/faq_repo.dart';
import 'package:embone/features/client/menu/view/cubit/faqs_state.dart';

class FaqsCubit extends Cubit<FaqsState> {
  final FaqRepo faqRepo;
  List<FaqModel> faqs = [];
  FaqsCubit(this.faqRepo) : super(FaqsInitial());
  void init() {
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    if (isClosed) return;

    emit(FaqLoading());
    Print.info("Starting to fetch FAQs");

    final result = await faqRepo.fetchFaqs();

    if (isClosed) return;

    result.fold(
      (error) {
        Print.error("Failed to fetch FAQs: $error");
        emit(FaqError(error));
      },
      (faqResponse) {
        faqs = faqResponse.data;
        Print.info("Fetched ${faqs.length} FAQs successfully");
        emit(FaqLoaded(faqResponse));
      },
    );
  }
}
