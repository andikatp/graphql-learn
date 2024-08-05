import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_learn/presentation/users/providers/user_provider.dart';
import 'package:graphql_learn/presentation/users/widgets/user_tile.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersRef = ref.watch(getUsersEventProvider);
    return Scaffold(
      body: usersRef.when(
        data: (users) => ListView.builder(
          itemBuilder: (context, index) => UserTile(user: users[index]),
          itemCount: users.length,
          padding: const EdgeInsets.all(16),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
