import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';

class AddressRepo {
  final ApiConsumer api;

  AddressRepo(this.api);
  Future<Either<String, List<Address>>> getUserAddresses() async {
    try {
      final response = await api.get(EndPoints.address);
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      final addresses = data.map((json) => Address.fromJson(json)).toList();
      return Right(addresses);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch addresses: $e');
    }
  }

  Future<Either<String, List<Address>>> updateAddress(
      int id, Address address) async {
    try {
      final formData = {
        'city': address.cityId ?? '',
        'lng': address.lng ?? '',
        'lat': address.lat ?? '',
        'address': address.address ?? '',
        '_method': 'PUT',
      };
      final response = await api.post(
        '${EndPoints.address}/$id',
        data: formData,
        isFormData: true,
      );
      final updatedAddress = Address.fromJson(response.data);
      return Right([updatedAddress]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to update address: $e');
    }
  }

  Future<Either<String, String>> deleteAddress(int id) async {
    try {
      final response = await api.delete('${EndPoints.address}/$id');
      return Right(response.data['message'] ?? 'Address deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to delete address: $e');
    }
  }

  Future<Either<String, String>> deleteAccount() async {
    try {
      final response = await api.delete(EndPoints.accountDelete);
      return Right(response.data['message'] ?? 'Account deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to delete address: $e');
    }
  }

  Future<Either<String, List<Address>>> addAddress({
    required String address,
    required String city,
    required String lat,
    required String lng,
  }) async {
    try {
      final formData = {
        'address': address,
        'city': city,
        'lat': lat,
        'lng': lng,
        '_method': 'POST',
      };
      final response = await api.post(
        EndPoints.address,
        data: formData,
        isFormData: true,
      );
      final newAddress = Address.fromJson(response.data);
      return Right([newAddress]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to add address: $e');
    }
  }
}
