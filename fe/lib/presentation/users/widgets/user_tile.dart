import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/presentation/router/app_router.dart';
import 'package:graphql_learn/presentation/users/controller/user_controller.dart';

class UserTile extends ConsumerWidget {
  const UserTile({required this.user, super.key});
  final UserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void editUser(UserEntity user) =>
        context.pushNamed(Routes.edit, extra: user);

    Future<void> deleteUser(String id) async {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} has been deleted'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.white,
          ),
        );
      }
      await ref.read(userControllerProvider.notifier).deleteUserEvent(user.id);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        tileColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => editUser(user),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => deleteUser(user.id),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        title: Text(user.name),
        subtitle: Text(user.username),
        leading: Text(user.id),
      ),
    );
  }
}
