import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/model/business_recent_view_model.dart';
import 'package:embone/features/client/menu/data/repo/business_repo.dart';
import 'package:embone/features/client/menu/view/cubit/business_state.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepo businessRepo;
  List<BusinessModel> businesses = [];

  BusinessCubit(this.businessRepo) : super(BusinessInitial());

  void init() {
    fetchBusinesses();
  }

  Future<void> fetchBusinesses() async {
    if (isClosed) return;

    emit(BusinessLoading());
    Print.info("Starting to fetch businesses");

    final result = await businessRepo.fetchBusinesses();

    if (isClosed) return;

    result.fold(
      (error) {
        Print.error("Failed to fetch businesses: $error");
        emit(BusinessError(error));
      },
      (businessResponse) {
        businesses = businessResponse.data;
        Print.info("Fetched ${businesses.length} businesses successfully");
        emit(BusinessLoaded(businessResponse));
      },
    );
  }
}
