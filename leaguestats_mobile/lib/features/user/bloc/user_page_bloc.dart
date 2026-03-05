import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart'; 
import 'package:meta/meta.dart';

part 'user_page_event.dart';
part 'user_page_state.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final UserService _userService;
  final StorageService _storageService =
      StorageService(); 

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

        
        if (email == null || email.isEmpty) {
          emit(
            UserPageError(
              message: "No se encontró un email válido para buscar el perfil",
            ),
          );
          return;
        }

        print("Buscando perfil para: $email");

        
        var userProfile = await _userService.getUserProfileByEmail(email);

        print("Perfil recibido: ${userProfile.username}");
        emit(UserPageSuccess(dto: userProfile));
      } catch (e) {
        emit(UserPageError(message: e.toString()));
      }
    });

    
    on<UserAddBalanceEvent>((event, emit) async {
      emit(UserPageLoading());
      try {
        
        await _userService.addBalance(event.amount);

        
        String? email = await _storageService.getEmail();
        var updatedProfile = await _userService.getUserProfileByEmail(email!);

        
        
        emit(UserPageSuccess(dto: updatedProfile));
      } catch (e) {
        
        emit(UserAddBalanceError(message: e.toString()));
      }
    });
  }
}
