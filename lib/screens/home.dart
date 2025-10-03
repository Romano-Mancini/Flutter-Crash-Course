import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crash_course/services/auth/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Welcome home ${user.name}!')),
    );
  }
}
