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
          child: const Icon(Icons.add),),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: usersRef.when(
          data: (users) => ListView.builder(
            itemBuilder: (context, index) => UserTile(user: users[index]),
            itemCount: users.length,
            padding: const EdgeInsets.all(16),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error \n $stackTrace'),
          ),
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}
