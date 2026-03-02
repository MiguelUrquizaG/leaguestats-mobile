import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart'; // Importa tu storage
import 'package:meta/meta.dart';

part 'user_page_event.dart';
part 'user_page_state.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final UserService _userService;
  final StorageService _storageService =
      StorageService(); // Instancia del storage

  UserPageBloc(this._userService) : super(UserPageInitial()) {
    on<UserProfileByEmailEvent>((event, emit) async {
      emit(UserPageLoading());

      try {
        String? email;

        if (event.email != null && event.email!.isNotEmpty) {
          email = event.email;
        } else {
          email = await _storageService.getEmail();
        }

        // 2. Validación de seguridad
        if (email == null || email.isEmpty) {
          emit(
            UserPageError(
              message: "No se encontró un email válido para buscar el perfil",
            ),
          );
          return;
        }

        print("Buscando perfil para: $email");

        // 3. Petición al servicio
        var userProfile = await _userService.getUserProfileByEmail(email);

        print("Perfil recibido: ${userProfile.username}");
        emit(UserPageSuccess(dto: userProfile));
      } catch (e) {
        emit(UserPageError(message: e.toString()));
      }
    });

    // En el constructor del UserPageBloc
    on<UserAddBalanceEvent>((event, emit) async {
      emit(UserPageLoading());
      try {
        // 1. Llamamos al backend para añadir el dinero
        await _userService.addBalance(event.amount);

        // 2. Volvemos a pedir el perfil actualizado
        String? email = await _storageService.getEmail();
        var updatedProfile = await _userService.getUserProfileByEmail(email!);

        // 3. Emitimos tu estado de éxito general.
        // Esto hará que toda la app reaccione y actualice el número del saldo.
        emit(UserPageSuccess(dto: updatedProfile));
      } catch (e) {
        // Usamos el error específico que creaste
        emit(UserAddBalanceError(message: e.toString()));
      }
    });
  }
}
