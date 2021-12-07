import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  final String title;
  final String text;
  final String? avatarIcon;
  final String username;
  final VoidCallback onQuestionPressed;
  final VoidCallback onUserPressed;
  final int favorite;
  final VoidCallback onFavoritePressed;

  const AnswerCard(
      {Key? key,
      required this.title,
      required this.text,
      required this.avatarIcon,
      required this.username,
      required this.onQuestionPressed,
      required this.onUserPressed,
      required this.favorite,
      required this.onFavoritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: InkWell(
        onTap: onQuestionPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onUserPressed,
                    child: CircleAvatar(
                      foregroundImage: avatarIcon == null
                          ? const NetworkImage(
                              'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6')
                          : NetworkImage(avatarIcon!),
                      backgroundImage: const NetworkImage(
                          'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6'),
                      radius: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(username,
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                ],
              ),
              Text(
                text,
                maxLines: 10,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onFavoritePressed,
                    style: OutlinedButton.styleFrom(
                      onSurface: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      primary: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: const [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 30,
                            ),
                            Text(
                              "お礼",
                            ),
                          ],
                        ),
                        Text(favorite.toString())
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
