import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:meta/meta.dart';

part 'logout_page_event.dart';
part 'logout_page_state.dart';

class LogoutPageBloc extends Bloc<LogoutPageEvent, LogoutPageState> {
  final StorageService _storageService = StorageService();

  LogoutPageBloc() : super(LogoutPageInitial()) {
    on<DoLogoutPageEvent>((event, emit) async {
      emit(LogoutPageLoading());

      try {
        // Eliminar todo el almacenamiento (token y email)
        await _storageService.deleteAll();
        emit(LogoutPageSuccess());
      } catch (e) {
        emit(LogoutPageError(message: e.toString()));
      }
    });
  }
}
