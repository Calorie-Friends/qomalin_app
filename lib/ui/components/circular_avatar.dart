
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularAvatarIcon extends StatelessWidget {
  final String? avatarIconUrl;
  final VoidCallback? onPressed;

  const CircularAvatarIcon({Key? key, required this.avatarIconUrl, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: CircleAvatar(
        foregroundImage: avatarIconUrl == null
            ? const NetworkImage(
            'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6')
            : NetworkImage(avatarIconUrl!),
        backgroundImage: const NetworkImage(
            'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6'),
        radius: 16,
      ),
    );
  }


}