import 'package:dio/dio.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
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
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
