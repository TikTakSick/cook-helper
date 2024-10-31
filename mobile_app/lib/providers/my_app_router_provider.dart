import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'shared_recipe_url_provider.dart';
import 'auth_provider.dart';

// views
import '../views/pages/my_page.dart';
import '../views/pages/login_page.dart';
import '../views/pages/recipe_add_page.dart';
import '../views/pages/setting_page.dart';
import '../views/bottom_navigation_settings.dart';

final myAppRouterProvider = Provider.autoDispose<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  // 認証関連のプロパティを監視
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
  // 共有されたレシピのURL
  final sharedRecipeUrl = ref.watch(sharedRecipeUrlProvider);
  bool handleSharedRecipeUrl = (sharedRecipeUrl != null ? true : false);

  // return 部分
  return GoRouter(
    initialLocation: '/login-page',
    navigatorKey: rootNavigatorKey,
    errorBuilder: (context, state) {
      debugPrint("Error: ${state.error}");
      return Text("Error: ${state.error}");
    },
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
            },
            redirect: (context, state) {
              if (handleSharedRecipeUrl) {
                final recipeUrlForQueryParameters = sharedRecipeUrl;
                handleSharedRecipeUrl = false;
                return state.namedLocation(
                  'recipe-add-page',
                  queryParameters: {
                    'sharedRecipeUrl': recipeUrlForQueryParameters!
                  },
                );
              }
              return null;
            },
          ),
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
          presentLocation: $presentLocation\n
          sharedRecipeUrl: $sharedRecipeUrl\n
          """);
      if (authloading || authHasError || userNotExist) {
        debugPrint("authState.isLoading: Loading,error, or no user");
        return "/login-page";
      } else if (!userEmailVerified) {
        return "/login-page";
      } else if (presentLocation == '/login-page') {
        return '/my-page';
      }
      return null;
    },
  );
});
