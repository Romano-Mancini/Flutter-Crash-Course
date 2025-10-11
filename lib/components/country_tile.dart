import 'package:flutter/material.dart';
import 'package:flutter_crash_course/models/countries_state.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({super.key, required this.country});

  final Country country;

  String formatPopulation(int population) {
    if (population >= 1e9) {
      return '${(population / 1e9).toStringAsFixed(1)}B';
    } else if (population >= 1e6) {
      return '${(population / 1e6).toStringAsFixed(1)}M';
    } else if (population >= 1e3) {
      return '${(population / 1e3).toStringAsFixed(1)}K';
    } else {
      return population.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(country.flagUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: 64.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(245),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.0),
                bottomRight: Radius.circular(32.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  country.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.location_city, size: 30),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              country.capital,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 30),
                        const SizedBox(width: 8.0),
                        Text(
                          formatPopulation(country.population),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
