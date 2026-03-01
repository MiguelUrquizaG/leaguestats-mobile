import 'package:leaguestats_mobile/core/models/countries/country_list_response_dto.dart';

abstract class CountryInterface {
  Future<List<CountryListResponseDto>> getAll();
}
