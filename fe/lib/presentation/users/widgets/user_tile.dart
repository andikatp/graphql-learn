import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/presentation/users/controller/user_controller.dart';

class UserTile extends ConsumerWidget {
  const UserTile({required this.user, super.key});
  final UserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> deleteUser(String id) async {
      await ref.read(userControllerProvider.notifier).deleteUserEvent(user.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} has been deleted'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.white,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        tileColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onLongPress: () => deleteUser(user.id),
        title: Text(user.name),
        subtitle: Text(user.username),
        leading: Text(user.id),
      ),
    );
  }
}
