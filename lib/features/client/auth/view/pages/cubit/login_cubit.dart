import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/login_state.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginCubit(this.loginRepo) : super(LoginInitial());

  String determineType(String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailRegex.hasMatch(value)) {
      return 'email';
    }

    final phoneRegex = RegExp(r'^\+?\d{8,}$');
    if (phoneRegex.hasMatch(value)) {
      return 'phone';
    }
    return 'unknown';
  }

  //! Login
  Future<void> login() async {
    emit(LoginLoading());

    final value = valueController.text.trim();
    final password = passwordController.text.trim();
    final type = determineType(value);

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (type == 'unknown') {
      Print.error('Invalid value format');
      emit(LoginError(message: 'Invalid email or phone format'));
      return;
    }

    final response = await loginRepo.loginUser(
      value,
      password,
      type,
    );
    response.fold(
      (l) {
        Print.error(l);
        emit(LoginError(message: l));
      },
      (r) async {
        // ignore: unused_local_variable
        bool isVerified = false;
        if (r.data!.isVerified == true || r.data!.isVerified == null) {
          isVerified = true;
          sl<CacheHelper>().setData(ApiKey.token, r.data!.user!.token!);
          sl<CacheHelper>()
              .saveData(key: AppConstants.token, value: r.data?.user?.token);
          Print.success("Welcome ${r.data?.user?.firstName ?? ""}");
          // await sl<GlobalCubit>().getUserProfile();
        } else if (r.data!.isVerified == false) {
          isVerified = false;
        }
        emit(LoginSuccess(
            isVerified: isVerified, type == 'email' ? true : false));
      },
    );
  }

  @override
  Future<void> close() {
    valueController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
