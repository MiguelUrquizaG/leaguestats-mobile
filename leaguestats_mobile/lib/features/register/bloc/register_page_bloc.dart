import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/auth/register_request_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/register_response_dto.dart';
import 'package:leaguestats_mobile/core/services/auth_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

part 'register_page_event.dart';
part 'register_page_state.dart';

class RegisterPageBloc extends Bloc<RegisterPageEvent, RegisterPageState> {
	RegisterPageBloc(AuthService authService, StorageService storageService)
			: super(RegisterPageInitial()) {
		on<RegisterEvent>((event, emit) async {
			emit(RegisterPageLoading());

			if (event.dto.email == null ||
					event.dto.email!.trim().isEmpty ||
					event.dto.password == null ||
					event.dto.password!.isEmpty) {
				emit(RegisterPageError(message: 'Campos requeridos'));
				return;
			}

			try {
				final response = await authService.register(event.dto);

				if (response.token != null && response.token!.isNotEmpty) {
					await storageService.saveToken(response.token.toString());
				}

				emit(RegisterPageSuccess(dto: response));
			} catch (e) {
				emit(RegisterPageError(message: e.toString()));
			}
		});
	}
}
