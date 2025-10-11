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
  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countriesNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Country')),
      body:
          (countriesState.isLoading)
              ? const Center(child: CircularProgressIndicator())
              : Autocomplete<String>(
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
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        hintText: 'Enter country name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            textEditingController.clear();
                          },
                        ),
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
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
