import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_learn/presentation/router/app_router.dart';
import 'package:graphql_learn/presentation/users/controller/user_controller.dart';
import 'package:graphql_learn/presentation/users/widgets/user_tile.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersRef = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(Routes.add),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: switch (usersRef) {
          AsyncData(:final value) => value.isEmpty
              ? const Center(
                  child: Text('No users found'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => UserTile(user: value[index]),
                  itemCount: value.length,
                  padding: const EdgeInsets.all(16),
                ),
          AsyncError(:final error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, size: 50),
                  Text(error.toString(), textAlign: TextAlign.center,),
                ],
              ),
            ),
          _ => const Center(
              child: CupertinoActivityIndicator(),
            )
        },
      ),
    );
  }
}
