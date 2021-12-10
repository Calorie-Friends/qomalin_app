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

  const AnswerCardList(
      {Key? key,
      required this.onAnswerCardSelectedListener,
      required this.onAnswerUserPressedListener,
      required this.onAnswerFavoritePressedListener,
      required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemBuilder: (BuildContext context, int index) {
        final answer = answers[index];
        return AnswerCard(
          text: answer.text,
          avatarIcon: answer.user.avatarIcon,
          username: answer.user.username,
          onAnswerPressed: () {
            onAnswerCardSelectedListener(answer);
          },
          onUserPressed: () {
            onAnswerUserPressedListener(answer.user);
          },
          onFavoritePressed: () {
            onAnswerFavoritePressedListener(answer);
          },

          // TODO: favorite数実装時に正しい値が入るようにする。
          favorite: 0,
        );
      },
      itemCount: answers.length,
    );
  }
}
