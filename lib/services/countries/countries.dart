import 'package:flutter_crash_course/models/countries_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CountriesService {
  Future<List<String>> fetchCountries() async {
    // Simulate a network call
    final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all?fields=name'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load countries');
    }
    final names = <String>[];
    for (var country in json.decode(response.body)) {
      names.add(country['name']['common']);
    }
    return names;
  }

  Future<Country> fetchCountryDetails(String countryName) async {
    final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/name/$countryName'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load country details');
    }
    final data = json.decode(response.body)[0];
    return Country(
      name: data['name']['common'],
      code: data['cca2'],
      population: data['population'],
      capital:
          (data['capital'] as List).isNotEmpty ? data['capital'][0] : 'N/A',
      flagUrl: data['flags']['png'],
    );
  }

  Future<void> saveCountries(List<Country> countries) async {
    final prefs = await SharedPreferences.getInstance();
    final countryList =
        countries.map((country) => json.encode(country.toJson())).toList();
    await prefs.setStringList('saved_countries', countryList);
  }

  Future<List<Country>> loadSavedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final countryList = prefs.getStringList('saved_countries') ?? [];
    return countryList
        .map((countryStr) => Country.fromJson(json.decode(countryStr)))
        .toList();
  }
}
