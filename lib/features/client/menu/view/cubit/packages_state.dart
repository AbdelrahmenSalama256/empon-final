
import 'package:embone/features/client/menu/data/model/cities_model.dart';
import 'package:embone/features/client/menu/data/model/packages_model.dart';

class PackagesState {
  const PackagesState();
}

final class PackagesInitial extends PackagesState {}

class PackagesLoading extends PackagesState {}

class PackagesLoaded extends PackagesState {
  final List<PackageModel> packagesResponse;

  PackagesLoaded(this.packagesResponse);
}

class PackagesError extends PackagesState {
  final String message;

  const PackagesError(this.message);
}
class CitiesLoaded extends PackagesState {
  final List<City> cities;
  CitiesLoaded(this.cities);
}

class CitiesError extends PackagesState {
  final String message;
  CitiesError(this.message);
}
