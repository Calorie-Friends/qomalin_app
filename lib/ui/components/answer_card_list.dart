import 'package:flutter/cupertino.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/ui/components/answer_card.dart';

typedef AnswerCardSelectedListener = Function(Answer);
typedef AnswerUserPressedListener = Function(User);
typedef AnswerFavoritePressedListener = Function(Answer);
class AnswerCardList extends StatelessWidget {
  final List<Answer> answers;
  final AnswerCardSelectedListener onAnswerCardSelectedListener;
  final AnswerUserPressedListener onAnswerUserPressedListener;
  final AnswerFavoritePressedListener onAnswerFavoritePressedListener;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AnswerCardList(
      {Key? key,
      required this.onAnswerCardSelectedListener,
      required this.onAnswerUserPressedListener,
      required this.onAnswerFavoritePressedListener,
      required this.answers,
      this.physics,
      this.shrinkWrap = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemBuilder: (BuildContext context, int index) {
        final answer = answers[index];
        return AnswerCard(
          text: answer.text,
          avatarIcon: answer.user?.avatarIcon,
          username: answer.user?.username ?? '',
          onAnswerPressed: () {
            onAnswerCardSelectedListener(answer);
          },
          onUserPressed: () {
            if(answer.user != null) {
              onAnswerUserPressedListener(answer.user!);
            }
          },
          onFavoritePressed: () {
            onAnswerFavoritePressedListener(answer);
          },

          favorite: answer.thankIds.length,
        );
      },
      itemCount: answers.length,
    );
  }
}
