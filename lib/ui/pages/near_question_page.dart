
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/notifier/near_questions_notifier.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/components/question_card_list.dart';

class NearQuestionPage extends ConsumerWidget {
  const NearQuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(QuestionProviders.nearQuestionNotifierProvider().notifier).fetch(),
      builder: (context, snapshot) {

        return RefreshIndicator(
          child: const NotifierQuestionList(),
          onRefresh: () {
            return ref.read(QuestionProviders.nearQuestionNotifierProvider().notifier).fetch();
          },
        );
      }
    );
  }

}

class NotifierQuestionList extends ConsumerWidget {
  const NotifierQuestionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionState = ref.watch(QuestionProviders.nearQuestionNotifierProvider());
    log("state type;${questionState.type}");
    final questions = questionState.questions;
    if(questionState.type == NearQuestionsStateType.error) {
      return Container(
        alignment: Alignment.center,
        child: const Text("取得失敗")
      );
    }
    if(questionState.type == NearQuestionsStateType.loading) {
      return const Center(
          child: CircularProgressIndicator(
          )
      );
    }
    if(questionState.type == NearQuestionsStateType.fixed && questions.isEmpty) {
      return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("投稿は何もありません"),
            TextButton(onPressed: () {
              //return ref.read(QuestionProviders.nearQuestionNotifierProvider().notifier).fetch();
              ref.read(QuestionProviders.nearQuestionNotifierProvider().notifier).fetch();
              //Future.microtask(() => ref.read(QuestionProviders.nearQuestionNotifierProvider().notifier).fetch());
            }, child: const Text("再読み込み"))
          ],
        ),
      );
    }
    return QuestionCardList(
      onQuestionSelectedListener: (q){
        context.push('/questions/${q.id}/show');
      }, onQuestionUserPressedListener: (u){}, questions: questions);
  }

}