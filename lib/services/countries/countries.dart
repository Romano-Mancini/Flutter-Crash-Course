import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crash_course/models/countries_state.dart';
import 'package:flutter_crash_course/services/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CountriesService {
  final _db = FirebaseFirestore.instance;

  Future<List<String>> fetchCountries() async {
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

  Future<void> saveCountries(String uid, List<Country> countries) async {
    try {
      await _db.collection('users').doc(uid).set({
        'saved_countries':
            countries.map((country) => country.toJson()).toList(),
      });
    } catch (e) {
      print('Error saving countries: $e');
    }
  }

  Future<List<Country>> loadSavedCountries(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        final savedCountries = data?['saved_countries'] as List<dynamic>? ?? [];
        return savedCountries
            .map((countryJson) => Country.fromJson(countryJson))
            .toList();
      }
    } catch (e) {
      print('Error loading saved countries: $e');
    }
    return [];
  }
}
