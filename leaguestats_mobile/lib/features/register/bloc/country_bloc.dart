import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/countries/country_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/country_service.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 600);

  CountryBloc(this._countryService) : super(CountryInitial()) {
    on<LoadCountriesEvent>((event, emit) async {
      emit(CountryLoading());
      
      int attemptCount = 0;
      Exception? lastError;
      
      while (attemptCount < _maxRetries) {
        attemptCount++;
        try {
          final countries = await _countryService.getAll();
          emit(CountryLoaded(countries: countries));
          return;
        } catch (e) {
          lastError = Exception(e);
          if (attemptCount < _maxRetries) {
            await Future.delayed(_retryDelay);
          }
        }
      }
      
      emit(CountryError(message: lastError?.toString() ?? 'Error cargando países'));
    });
  }

  final CountryService _countryService;
}
