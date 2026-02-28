import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/services/auth_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

part 'register_page_event.dart';
part 'register_page_state.dart';

class RegisterPageBloc extends Bloc<RegisterPageEvent, RegisterPageState> {
  RegisterPageBloc() : super(RegisterPageInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(RegisterPageLoading());
      await Future.delayed(const Duration(seconds: 1));
    


      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        // var registerResponse = await auth_service.re  AuthService auth_service,StorageService storage_service
        emit(RegisterPageSuccess());

      } else {
        emit(RegisterPageError(message: 'Campos requeridos'));
      }
    });
  }
}
