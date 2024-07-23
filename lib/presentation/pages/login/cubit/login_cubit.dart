import 'package:bloc/bloc.dart';
import 'package:eventsapp/data/dtos/request/login_request_dto.dart';
import 'package:eventsapp/data/dtos/request/register_request_dto.dart';
import 'package:eventsapp/data/dtos/response/login_response_dto.dart';
import 'package:eventsapp/data/source/api_data.dart';
import 'package:eventsapp/presentation/pages/home/home.dart';
import 'package:eventsapp/presentation/pages/login/login_page.dart';
import 'package:eventsapp/presentation/pages/login/widgets/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final logger = Logger();
  final ApiClient client;

  LoginCubit(this.client) : super(LoginInitial());

  void login(String email, String password, BuildContext context) async {
    emit(LoginLoading());
    try {
      final request = LoginRequestDto(email: email, password: password);
      final response = await client.login(request);
      logger.i(response.userId);
      emit(LoginSuccess(response));
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('userId', response.userId);
      prefs.setString('token', response.token);
      await SuccessfulLoginDialog()
          .show(
        context: context,
        duration: const Duration(seconds: 2),
      )
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      });
    } catch (e) {
      logger.e(e);
      emit(LoginError());
    }
  }

  void register(String username, String email, String password,
      BuildContext context) async {
    emit(LoginLoading());
    try {
      final request = RegisterRequestDto(
          username: username, email: email, password: password);
      final response = await client.register(request);
      logger.i(response.userId);
      emit(LoginSuccess(response));
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('userId', response.userId);
      prefs.setString('token', response.token);
      await SuccessfulLoginDialog()
          .show(
        context: context,
        duration: const Duration(seconds: 2),
      )
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      });
    } catch (e) {
      logger.e(e);
      emit(LoginError());
    }
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('token');

    emit(Logout());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}
