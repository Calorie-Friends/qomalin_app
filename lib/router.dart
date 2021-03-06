import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/ui/pages/answer_editor_page.dart';
import 'package:qomalin_app/ui/pages/main_page.dart';
import 'package:qomalin_app/ui/pages/profile_editor_page.dart';
import 'package:qomalin_app/ui/pages/photos_page.dart';
import 'package:qomalin_app/ui/pages/question_detail_page.dart';
import 'package:qomalin_app/ui/pages/question_editor_page.dart';
import 'package:qomalin_app/ui/pages/signup_page.dart';
import 'package:qomalin_app/ui/pages/splash_page.dart';
import 'package:qomalin_app/ui/pages/user_detail_page.dart';

import 'main.dart';
import 'notifier/auth_notifier.dart';

final router = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  log("更新されました${authState.type}");
  return GoRouter(
      routes: [
        GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return MaterialPage(key: state.pageKey, child: const MainPage());
            }),
        GoRoute(
            path: '/questions/edit',
            pageBuilder: (context, state) {
              return MaterialPage(
                  key: state.pageKey,
                  child: QuestionEditorPage(
                    latitude: double.tryParse(state.queryParams['lat'] ?? ''),
                    longitude: double.tryParse(state.queryParams['lng'] ?? '')
                  )
              );
            }),
        GoRoute(
            path: "/questions/:questionId/answers/create",
            pageBuilder: (context, state) {
              return MaterialPage(key: state.pageKey, child: AnswerEditorPage(questionId: state.params['questionId']!,));
            }
        ),
        GoRoute(
            path: "/questions/:questionId/show",
            name: 'questionDetail',
            pageBuilder: (context, state) {
              return MaterialPage(
                  key: state.pageKey,
                  child: QuestionDetailPage(questionId: state.params['questionId']!)
              );
            }
        ),
        GoRoute(
          path: "/me/profile/edit",
          pageBuilder: (context, state){
            return MaterialPage(key: state.pageKey, child: const ProfileEditorPage());
          }
        ),
        GoRoute(
            path: "/photos",
            name: "photosPage",
            pageBuilder: (context, state) {
              return MaterialPage(key: state.pageKey,
                child: PhotosPage(
                  imageUrls: state.extra as List<String>,
                  current: int.parse(state.queryParams['current']!),
                ),
              );
            }
        ),
        GoRoute(
          path: "/users/:userId/show",
          name: "userDetail",
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: UserDetailPage(
                userId: state.params['userId']!,
              )
            );
          }
        ),
        GoRoute(
            path: '/signup',
            pageBuilder: (context, state) {
              return MaterialPage(
                  key: state.pageKey, child: const SignupPage());
            }),
        if (authState.type == AuthStateType.loading)
          GoRoute(
            path: '/splash',
            pageBuilder: (context, state) {
              return MaterialPage(
                  key: state.pageKey, child: const SplashPage());
            },
          )
      ],
      errorPageBuilder: (context, state) {
        log('error:${state.error}');
        return MaterialPage(key: state.pageKey, child: const ErrorPage());
      },
      redirect: (state) {
        final authState = ref.read(authNotifierProvider);

        if (state.subloc != '/signup' &&
            authState.type == AuthStateType.unauthorized) {
          return '/signup';
        } else if (state.subloc != '/splash' &&
            authState.type == AuthStateType.loading) {
          return '/splash';
        }
        return null;
      });
});
