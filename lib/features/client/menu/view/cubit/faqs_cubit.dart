import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/model/contact_info_model.dart';
import 'package:embone/features/client/menu/data/model/faq_model.dart';
import 'package:embone/features/client/menu/data/repo/faq_repo.dart';
import 'package:embone/features/client/menu/view/cubit/faqs_state.dart';

class FaqsCubit extends Cubit<FaqsState> {
  final FaqRepo faqRepo;
  List<FaqModel> faqs = [];
  ContactInfo? contactInfo;
  FaqsCubit(this.faqRepo) : super(FaqsInitial());
  void init() {
    fetchFaqs();
    fetchContactInfo();
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

  Future<void> fetchContactInfo() async {
    if (isClosed) return;
    emit(FaqLoading());
    final result = await faqRepo.fetchContactInfo();
    if (isClosed) return;
    result.fold(
      (error) {
        emit(FaqError(error));
      },
      (contactResponse) {
        contactInfo = contactResponse.data;
        emit(ContactInfoLoaded(contactResponse));
      },
    );
  }
}
