import 'package:flutter_crash_course/models/countries_state.dart';
import 'package:flutter_crash_course/services/auth/auth_notifier.dart';
import 'package:flutter_crash_course/services/countries/countries.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countries_notifier.g.dart';

@riverpod
class CountriesNotifier extends _$CountriesNotifier {
  final CountriesService _countriesService = CountriesService();

  @override
  CountriesState build() {
    return CountriesState();
  }

  init() async {
    state = CountriesState(isLoading: true);
    final uid = ref.read(authNotifierProvider).uid;
    try {
      final countries = await _countriesService.fetchCountries();
      final savedCountries = await _countriesService.loadSavedCountries(uid);
      state = CountriesState(
        countries: countries,
        savedCountries: savedCountries,
        isLoading: false,
      );
    } catch (e) {
      state = CountriesState(error: e.toString(), isLoading: false);
    }
  }

  addCountry(String countryName) async {
    state = state.copyWith(isLoading: true);
    final uid = ref.read(authNotifierProvider).uid;
    try {
      final countryDetails = await _countriesService.fetchCountryDetails(
        countryName,
      );
      final updatedSavedCountries = List<Country>.from(state.savedCountries)
        ..add(countryDetails);
      await _countriesService.saveCountries(uid, updatedSavedCountries);
      state = state.copyWith(
        savedCountries: updatedSavedCountries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
