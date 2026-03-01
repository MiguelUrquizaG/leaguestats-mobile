import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/countries/country_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/country_service.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc(this._countryService) : super(CountryInitial()) {
    on<LoadCountriesEvent>((event, emit) async {
      emit(CountryLoading());
      try {
        final countries = await _countryService.getAll();
        emit(CountryLoaded(countries: countries));
      } catch (e) {
        emit(CountryError(message: e.toString()));
      }
    });
  }

  final CountryService _countryService;
}
