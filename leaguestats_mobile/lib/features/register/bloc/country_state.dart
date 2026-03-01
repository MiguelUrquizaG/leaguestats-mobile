part of 'country_bloc.dart';

abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  CountryLoaded({required this.countries});

  final List<CountryListResponseDto> countries;
}

class CountryError extends CountryState {
  CountryError({required this.message});

  final String message;
}
