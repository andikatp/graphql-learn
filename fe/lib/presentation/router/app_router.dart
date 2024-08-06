import 'package:go_router/go_router.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/presentation/home/screens/home_page.dart';
import 'package:graphql_learn/presentation/users/screens/add_user.dart';
import 'package:graphql_learn/presentation/users/screens/users_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        name: Routes.home,
        path: Routes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: Routes.users,
        path: Routes.users,
        builder: (context, state) => const UsersPage(),
      ),
      GoRoute(
        name: Routes.add,
        path: Routes.add,
        builder: (context, state) => const AddUserPage(),
      ),
      GoRoute(
        name: Routes.edit,
        path: Routes.edit,
        builder: (context, state) {
          final user = state.extra! as UserEntity;
          return AddUserPage(user: user);
        },
      ),
    ],
  );
}

class Routes {
  Routes._();
  static const home = '/';
  static const users = '/users';
  static const add = '/add-user';
  static const edit = '/edit-user';
}
