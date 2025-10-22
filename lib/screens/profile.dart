import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crash_course/components/button.dart';
import 'package:flutter_crash_course/services/auth/auth_notifier.dart';
import 'package:flutter_crash_course/services/router/router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: MyButton(
                loading: false,
                text: 'Logout',
                submit: () {
                  ref.read(authNotifierProvider.notifier).logout();
                  context.router.replaceAll([const LoginRoute()]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
