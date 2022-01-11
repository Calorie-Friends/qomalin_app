import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/components/question_card_list.dart';

final _userQuestionsStreamProvider = StreamProvider.autoDispose.family((ref, String userId) {
  return ref.read(QuestionProviders.questionServiceProvider()).questionsByUser(userId: userId);
});

class UserQuestionList extends ConsumerWidget {
  final userId;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  UserQuestionList(this.userId, {Key? key, this.shrinkWrap = false, this.physics}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    AsyncValue<List<Question>> latestQuestionsStream = ref.watch(_userQuestionsStreamProvider(userId));

    return latestQuestionsStream.when(
        data: (questions){
          return QuestionCardList(
              onQuestionSelectedListener: (q){
                context.push('/questions/${q.id}/show');
              },
              onQuestionUserPressedListener: (u){},
              questions: questions,
              shrinkWrap: shrinkWrap,
              physics: physics,
          );
        },
        error: (err, stack){
          return const Text("取得失敗");
        },
        loading: (){
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}