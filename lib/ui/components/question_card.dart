import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qomalin_app/ui/components/circular_avatar.dart';

class QuestionCard extends StatelessWidget {
  final String title;
  final String text;
  final String? avatarIcon;
  final String username;
  final VoidCallback onQuestionPressed;
  final VoidCallback onUserPressed;

  const QuestionCard(
      {Key? key,
        required this.title,
        required this.text,
        required this.avatarIcon,
        required this.username,
        required this.onQuestionPressed,
        required this.onUserPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: onQuestionPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  text,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CircularAvatarIcon(avatarIconUrl: avatarIcon, onPressed: onUserPressed),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(username,
                        style: const TextStyle(
                          fontSize: 18,
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}