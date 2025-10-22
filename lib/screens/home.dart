import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crash_course/components/button.dart';
import 'package:flutter_crash_course/components/country_tile.dart';
import 'package:flutter_crash_course/services/countries/countries_notifier.dart';
import 'package:flutter_crash_course/services/router/router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _refreshCountries());
  }

  Future<void> _refreshCountries() async {
    await ref.read(countriesNotifierProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countriesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Countries')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushRoute(const ProfileRoute());
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.person),
      ),
      body: ListView.builder(
        itemCount: countriesState.savedCountries.length + 1,
        itemBuilder: (context, index) {
          if (index == countriesState.savedCountries.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 64.0,
              ),
              child: MyButton(
                loading: false,
                text: 'Add Country',
                submit: () {
                  context.pushRoute(const AddCountryRoute());
                },
              ),
            );
          }
          final country = countriesState.savedCountries[index];
          return CountryTile(country: country);
        },
      ),
    );
  }
}
