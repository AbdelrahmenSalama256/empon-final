import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

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
      emit(const LoginError(message: 'Invalid email or phone format'));
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
        sl<CacheHelper>()
            .saveData(key: AppConstants.token, value: r.data?.user?.token);
        Print.success("Welcome ${r.data?.user?.firstName ?? ""}");
        await sl<GlobalCubit>().getUserProfile();

        emit(LoginSuccess());
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
