import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crash_course/services/countries/countries_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AddCountryScreen extends ConsumerStatefulWidget {
  const AddCountryScreen({super.key});

  @override
  ConsumerState<AddCountryScreen> createState() => _AddCountryScreenState();
}

class _AddCountryScreenState extends ConsumerState<AddCountryScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countriesNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Country')),
      body:
          (_loading || countriesState.isLoading)
              ? const Center(child: CircularProgressIndicator())
              : Autocomplete<String>(
                optionsMaxHeight: 800,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return countriesState.countries
                      .where(
                        (country) => country.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      )
                      .toList();
                },
                onSelected: (String selection) async {
                  await ref
                      .read(countriesNotifierProvider.notifier)
                      .addCountry(selection);
                  if (context.mounted) {
                    context.router.maybePop();
                  }
                },
              ),
    );
  }
}
