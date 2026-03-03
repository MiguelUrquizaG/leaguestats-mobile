import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/features/login/bloc/login_page_bloc.dart';
import 'package:meta/meta.dart';

part 'logout_page_event.dart';
part 'logout_page_state.dart';

class LogoutPageBloc extends Bloc<LogoutPageEvent, LogoutPageState> {
  LogoutPageBloc() : super(LogoutPageInitial()) {
    on<DoLogoutPageEvent>((event, emit) {
      emit(LogoutPageLoading());

      try {
        emit(LogoutPageSuccess());
      } catch (e) {
        emit(LogoutPageError(message: e.toString()));
      }
    });
  }
}
