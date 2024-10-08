import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_learn/presentation/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Go To Next Page'),
            ElevatedButton(
              onPressed: () => context.pushNamed(Routes.users),
              child: const Text('Next Page'),
            ),
          ],
        ),
      ),
    );
  }
}
