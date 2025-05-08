import 'package:dio/dio.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/locations/data/repo/locations_repo.dart';
import 'package:embone/features/client/menu/data/repo/profile_repo.dart';
import 'package:embone/features/client/menu/data/repo/wishlist_repo.dart';
import 'package:embone/features/client/notifications/data/repo/notifications_repo.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/shop/data/repo/shop_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/database/api/dio_consumer.dart';
import 'package:embone/core/network/local_network.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton(() => LoginRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => LocationRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ForgetPasswordRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => SearchRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ShopRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => HomeRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => NotificationsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => WishlistRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ProfileRepo(sl<DioConsumer>()));
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
