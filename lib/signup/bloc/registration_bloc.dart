// registration_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:task/data/database_helper.dart';
import 'package:task/models/user.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final _databaseHelper = DatabaseHelper();

  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationSubmitted>((event, emit) async {
      try {
        await _databaseHelper.saveUser(event.user);
        emit(RegistrationSuccess());
      } catch (e) {
        emit(RegistrationFailure(error: e.toString()));
      }
    });
  }
}
