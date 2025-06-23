import 'package:embone/features/client/menu/data/model/business_recent_view_model.dart';

class BusinessState {}

final class BusinessInitial extends BusinessState {}

class BusinessLoading extends BusinessState {}

class BusinessLoaded extends BusinessState {
  final BusinessResponseModel businessResponse;

  BusinessLoaded(this.businessResponse);
}

class BusinessError extends BusinessState {
  final String message;

  BusinessError(this.message);
}
