import 'package:bloc/bloc.dart';
import 'package:embone/features/business_account/home/data/models/business_account_model.dart';
import 'package:embone/features/business_account/home/data/repo/account_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'account_state.dart';

class BusinessAccountCubit extends Cubit<BusinessAccountState> {
  final BusinessAccountRepo repo;
  BusinessAccountResponse? accountData;
  BusinessAccountCubit(this.repo) : super(BusinessAccountInitial());

  Future<void> fetchBusinessAccount(int accountId) async {
    emit(BusinessAccountLoading());
    final result = await repo.fetchBusinessAccountById(accountId);
    result.fold(
      (error) => emit(BusinessAccountError(error)),
      (response) {
        accountData = response;
        emit(BusinessAccountLoaded(accountData!));
      },
    );
  }

  Future<bool> launchLocationUrl({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      if (kDebugMode) {
        print('Invalid coordinates: latitude=$latitude, longitude=$longitude');
      }
      return false;
    }

    final encodedLabel = label != null ? Uri.encodeComponent(label) : '';
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude${encodedLabel.isNotEmpty ? '&query_place_id=$encodedLabel' : ''}',
    );

    // Construct platform-specific URL for fallback
    final platformUrl = Uri.parse(
      'geo:$latitude,$longitude${encodedLabel.isNotEmpty ? '?q=$latitude,$longitude($encodedLabel)' : ''}',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        return await launchUrl(googleMapsUrl,
            mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(platformUrl)) {
          return await launchUrl(platformUrl,
              mode: LaunchMode.externalApplication);
        } else {
          if (kDebugMode) {
            print('Could not launch map URL: $googleMapsUrl or $platformUrl');
          }
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching map URL: $e');
      }
      return false;
    }
  }
}
