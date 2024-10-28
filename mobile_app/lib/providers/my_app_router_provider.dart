import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// views
import '../views/pages/my_page.dart';
import '../views/pages/login_page.dart';
import '../views/pages/recipe_add_page.dart';
import '../views/pages/setting_page.dart';
import '../views/bottom_navigation_settings.dart';

final myAppRouterProvider = Provider.autoDispose
    .family<GoRouter, String?>((ref, String? sharedRecipeUrl) {
  sharedRecipeUrl = sharedRecipeUrl;
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  final (authloading, authHasError, userEmailVerified, userNotExist) =
      ref.watch(
    authUserChangesProvider.select(
      (user) {
        return (
          user.isLoading,
          user.hasError,
          user.value?.emailVerified ?? false,
          user.value?.uid == null ? true : false,
        );
      },
    ),
  );

  return GoRouter(
    initialLocation: '/login-page',
    navigatorKey: rootNavigatorKey,
    errorBuilder: (context, state) => Text("Error: ${state.error}"),
    routes: <RouteBase>[
      GoRoute(
        name: 'login-page',
        path: '/login-page',
        parentNavigatorKey: rootNavigatorKey,
        builder: (BuildContext context, state) {
          return const LoginPage();
        },
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (BuildContext context, state, child) {
          return MyAppBottomNavigationBar(child: child);
        },
        routes: [
          GoRoute(
              name: 'my-page',
              path: '/my-page',
              parentNavigatorKey: shellNavigatorKey,
              builder: (BuildContext context, state) {
                return const MyPage();
              }),
          GoRoute(
              name: 'recipe-add-page',
              path: '/recipe-add-page',
              parentNavigatorKey: shellNavigatorKey,
              builder: (BuildContext context, state) {
                return RecipeAddPage(
                  sharedRecipeUrl: state.uri.queryParameters['sharedRecipeUrl'],
                );
              }),
          GoRoute(
            name: "setting-page",
            path: "/setting-page",
            parentNavigatorKey: shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return const SettingPage();
            },
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final presentLocation = state.matchedLocation;
      debugPrint("""\n
          user: ${userNotExist ? "no user" : "exists"}\n
          emailVerified: $userEmailVerified\n
          presentLocation: ${state.matchedLocation}\n
          sharedRecipeUrl: $sharedRecipeUrl\n
          """);
      if (authloading || authHasError || userNotExist) {
        debugPrint("authState.isLoading: Loading,error, or no user");
        return "/login-page";
      } else if (!userEmailVerified) {
        return "/login-page";
      } else if (sharedRecipeUrl != null) {
        final sharedRecipeUrlForQueryParameter = sharedRecipeUrl;
        debugPrint("sharedRecipeUrl: $sharedRecipeUrlForQueryParameter");
        sharedRecipeUrl = null;
        return state.namedLocation(
          'recipe-add-page',
          queryParameters: {
            'sharedRecipeUrl': sharedRecipeUrlForQueryParameter!
          },
        );
      } else if (presentLocation == '/login-page') {
        debugPrint("isLogining: true");
        return '/my-page';
      }
      return null;
    },
  );
});
