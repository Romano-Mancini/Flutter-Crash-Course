class CountriesState {
  final List<String> countries;
  final List<Country> savedCountries;
  final bool isLoading;
  final String? error;

  CountriesState({
    this.countries = const [],
    this.savedCountries = const [],
    this.isLoading = false,
    this.error,
  });

  CountriesState copyWith({
    List<String>? countries,
    List<Country>? savedCountries,
    bool? isLoading,
    String? error,
  }) {
    return CountriesState(
      countries: countries ?? this.countries,
      savedCountries: savedCountries ?? this.savedCountries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class Country {
  final String name;
  final String code;
  final int population;
  final String capital;
  final String flagUrl;

  Country({
    required this.name,
    required this.code,
    required this.population,
    required this.capital,
    required this.flagUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      population: json['population'],
      capital: json['capital'],
      flagUrl: json['flagUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'population': population,
      'capital': capital,
      'flagUrl': flagUrl,
    };
  }
}
