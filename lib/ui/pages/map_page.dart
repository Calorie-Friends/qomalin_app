import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/pages/home_page.dart';
import 'package:collection/collection.dart';

enum BottomSheetContentType {
  list, content
}

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MapState();
  }
}

class MapState extends ConsumerState {
  CameraPosition? _cameraPos;
  final Completer<GoogleMapController> _controller = Completer();

  //CameraPosition? _cameraPosition;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.6769883, 139.7588499),
    zoom: 14.4746,
  );


  @override
  void didChangeDependencies() async {
    final GoogleMapController controller = await _controller.future;
    Geolocator.getCurrentPosition().then((value) {
      controller.moveCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: _cameraPos?.zoom ?? 14
              )
          )
      );
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(QuestionProviders.questionMapNotifier());
    _controller.future.then((value) {
    });

    final questions = state.distancedBy().sorted((a, b) => a.createdAt.compareTo(b.createdAt)).toList();

    //NOTE: cameraPosStateはautoDisposeなためwatchをしておかないと勝手に解放されてしまう。

    final pageController = PageController(viewportFraction: 0.85);
    return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: state.questions
                .map((e) =>
                  Marker(
                    markerId: MarkerId(e.id),
                    position: LatLng(e.location.latitude, e.location.longitude),
                    onTap: () {
                      final index = questions.indexWhere((element) => element.id == e.id);
                      if(index >= 0) {
                        pageController.jumpToPage(index);
                      }
                    }
                  )
                ).toSet(),
              onCameraMove: (position) {
                // NOTE: 現在のカメラの位置を記録したいだけなのでsetStateなどは呼び出さない。
                _cameraPos = position;
              },
              onLongPress: (latLng) {

              },
              onCameraIdle: () async {
                log("onCameraIdle");
                final ct = await _controller.future;
                final visibleRegion = await ct.getVisibleRegion();

                final pos = _cameraPos;
                log("pos:$pos");
                if (pos == null) {
                  return;
                }
                ref.read(QuestionProviders
                    .questionMapNotifier()
                    .notifier).fetch(
                    LatLng(pos.target.latitude, pos.target.longitude),
                    visibleRegion
                );
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
            Align(
              child: SizedBox(
                height: 140,
                child: PageView.builder(
                  itemCount: questions.length,
                  controller: pageController,
                  itemBuilder: (BuildContext context, i) {
                    final q = questions[i];
                    return QuestionCard(title: q.title, text: q.text ?? "", avatarIcon: q.user?.avatarIcon, username: q.user?.username ?? "", onQuestionPressed: (){}, onUserPressed:(){});
                  },
                  onPageChanged: (index) async {
                    final controller = await _controller.future;
                    final q = questions[index];
                    controller.moveCamera(CameraUpdate.newLatLng(LatLng(q.location.latitude, q.location.longitude)));
                  },
                ),
              ),
              alignment: Alignment.bottomCenter,
            ),

            //const SafeArea(child: QuestionMapBottomSheet())
          ],
        )
    );
  }


}

