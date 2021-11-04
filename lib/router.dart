import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/ui/pages/signup_page.dart';
import 'package:qomalin_app/ui/pages/splash_page.dart';

import 'main.dart';
import 'notifier/auth_notifier.dart';


final router = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  print("更新されました${authState.type}");
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: MyHomePage(title: "test",));
          }
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: SignupPage());
        }
      ),
      if(authState.type == AuthStateType.Loading)
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: SplashPage());
          },
        )
    ],
    errorPageBuilder: (context, state) {
      print('error:${state.error}');
      return MaterialPage(key: state.pageKey, child: ErrorPage());
    },
    redirect: (state) {
      final authState = ref.read(authNotifierProvider);
      
      if(state.subloc != '/signup' && authState.type == AuthStateType.Unauthorized) {
        return '/signup';
      }else if(state.subloc != '/splash' && authState.type == AuthStateType.Loading) {
        return '/splash';
      }
      return null;
    }
  );
});