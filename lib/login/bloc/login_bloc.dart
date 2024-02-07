import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task/data/database_helper.dart';
import 'package:task/login/models/login_helper.dart';
import 'package:task/models/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      try {
        final user = await _databaseHelper.getUser(
          event.credentials.username,
          event.credentials.password,
        );

        if (user != null) {
          emit(LoginSuccess(user: user));
        } else {
          emit(LoginFailure(error: 'Invalid username or password'));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
