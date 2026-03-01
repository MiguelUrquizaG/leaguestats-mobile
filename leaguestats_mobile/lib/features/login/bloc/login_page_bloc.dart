import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/auth/login_request_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/login_response_dto.dart';
import 'package:leaguestats_mobile/core/services/auth_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:meta/meta.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc(AuthService auth_service, StorageService storage_service)
    : super(LoginPageInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginPageLoading());

      try {
        var login_response = await auth_service.login(event.dto);
        await storage_service.saveToken(login_response.token.toString());
        await storage_service.saveEmail(event.dto.email.toString());
        emit(LoginPageSuccess(dto: login_response));
      } catch (e) {
        emit(LoginPageError(message: e.toString()));
      }
    });
  }
}
