import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class PhotosPage extends ConsumerWidget {
  final List<String> imageUrls;
  final int current;
  const PhotosPage({required this.imageUrls, required this.current ,Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: PageView.builder(
          itemCount: imageUrls.length,
          controller: PageController(initialPage: current),
          itemBuilder: (BuildContext context, int index) {
            return PhotoView(imageProvider: NetworkImage(imageUrls[index]));
          }),
    );
  }
}