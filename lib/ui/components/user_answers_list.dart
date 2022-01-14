import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/providers/answer.dart';
import 'package:qomalin_app/ui/components/answer_card_list.dart';

final _userAnswersStreamProvider = StreamProvider.autoDispose.family((ref, String userId) {
  return ref.read(AnswerProviders.answerServiceProvider()).findByUser(userId: userId);
});

class UserAnswersList extends ConsumerWidget{
  final userId;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  UserAnswersList(this.userId, {Key? key, this.shrinkWrap = false, this.physics}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    AsyncValue<List<Answer>> latestAnswersStream = ref.watch(_userAnswersStreamProvider(userId));

    return latestAnswersStream.when(
        data: (answers){
          return AnswerCardList(
            onAnswerCardSelectedListener:(a) {},
            onAnswerUserPressedListener: (u) {},
            onAnswerFavoritePressedListener: (a) {},
            answers: answers,
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