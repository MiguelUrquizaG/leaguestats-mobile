import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/user_bet_dto.dart';
import 'package:leaguestats_mobile/core/services/bet_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:meta/meta.dart';

part 'bets_page_event.dart';
part 'bets_page_state.dart';

class BetsPageBloc extends Bloc<BetsPageEvent, BetsPageState> {
  BetsPageBloc(BetService betService) : super(BetsPageInitial()) {
    on<BetsGetActiveEvent>((event, emit) async {
      emit(BetsPageLoading());

      try {
        var bets = await betService.getActiveBets();
        emit(BetsPageActiveSuccess(dto: bets));
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });
    on<BetsPlaceEvent>((event, emit) async {
      // <-- IMPORTANTE: poner async
      emit(BetsPageLoading());

      try {
        // 1. Obtenemos el email y el usuario para sacar su ID
        final storageService = StorageService();
        final userService = UserService(); // Asegúrate de tener este import

        String? email = await storageService.getEmail();
        if (email == null) throw Exception("Usuario no logueado");

        var userProfile = await userService.getUserProfileByEmail(email);

        // 2. Le asignamos el ID al DTO que viene del modal
        event.dto.userId = userProfile.id;

        // 3. ¡LA LLAMADA A LA API QUE FALTABA!
        await betService.bet(event.dto);

        // 4. Si no hay error en la línea anterior, emitimos el éxito
        emit(BetsPlaceSuccess());
      } catch (e) {
        // Si Laravel devuelve error, lo atrapamos aquí
        emit(BetsPageError(message: e.toString()));
      }
    });
    // BUSCA ESTE BLOQUE Y ACTUALÍZALO
    on<LoadPreviousBetEvent>((event, emit) async {
      emit(BetsPageLoading());
      try {
        var data = await betService.checkAlreadyBetAmount(event.betId);

        emit(
          PreviousBetSuccess(
            amount: data['amount'],
            winnerSelected: data['winner_selected'], // <-- LE PASAMOS EL ID
          ),
        );
      } catch (e) {
        emit(PreviousBetSuccess(amount: 0, winnerSelected: null));
      }
    });

    on<WithdrawBetEvent>((event, emit) async {
      emit(BetsPageLoading());
      try {
        await betService.withdrawBet(event.betId);
        emit(WithdrawBetSuccess());
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });
    // En bets_page_bloc.dart

    // En bets_page_bloc.dart

    on<LoadUserBetsHistoryEvent>((event, emit) async {
      emit(BetsPageLoading());
      try {
        final storageService = StorageService();
        final userService = UserService();

        // 1. Buscamos el email
        String? email = await storageService.getEmail();
        if (email == null) throw Exception("No se encontró sesión activa");

        // 2. Buscamos el perfil para obtener el ID real de Laravel
        var userProfile = await userService.getUserProfileByEmail(email);

        // 3. Llamamos al servicio (que ya devuelve List<UserBetDto>)
        final List<UserBetDto> bets = await betService.getUserBetsById(
          userProfile.id!,
        );

        // 4. Emitimos el éxito
        emit(UserBetsHistorySuccess(bets: bets));
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });
  }
}
