import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/notifier/question_map_notifier.dart';
import 'package:qomalin_app/providers/firestore.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/pages/home_page.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
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

final _cameraPosState = StateProvider.autoDispose<CameraPosition?>((ref) => null);

class MapState extends ConsumerState {
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
            zoom: ref.read(_cameraPosState).state?.zoom ?? 14
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
                      onQuestionMarkerTapped(e);
                    }
                )
            ).toSet(),
            onCameraMove: (position) {
              // NOTE: 現在のカメラの位置を記録したいだけなのでsetStateなどは呼び出さない。
              ref.read(_cameraPosState).state = position;
            },
            onLongPress: (latLng) {

            },
            onCameraIdle: () async {
              final ct = await _controller.future;
              final visibleRegion = await ct.getVisibleRegion();

              final pos = ref.read(_cameraPosState).state;
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
          const SafeArea(child: QuestionMapBottomSheet())
        ],
      )
    );
  }

  Future onQuestionMarkerTapped(Question q) async {
    log("質問が選択されました:${q.title}");
  }
}

final _sheetControllerProvider = Provider.autoDispose<SheetController>((ref) {
  return SheetController();
});

class QuestionMapBottomSheet extends ConsumerWidget {

  const QuestionMapBottomSheet({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetController = ref.watch(_sheetControllerProvider);

    final cameraPos = ref.watch(_cameraPosState);
    final double bottomSheetHeight = (MediaQuery.of(context).size.height);

    final questionMapNotifier = ref.watch(QuestionProviders.questionMapNotifier());
    final geo = ref.read(geoFirestoreProvider);
    final questions = questionMapNotifier.questions.toList().sorted((a, b) {
      final aDistance = geo.point(latitude: a.location.latitude, longitude: a.location.longitude)
          .distance(lat: cameraPos.state?.target.latitude ?? 0, lng: cameraPos.state?.target.longitude ?? 0);
      final bDistance = geo.point(latitude: b.location.latitude, longitude: b.location.longitude)
          .distance(lat: cameraPos.state?.target.latitude ?? 0, lng: cameraPos.state?.target.longitude ?? 0);
      return aDistance.compareTo(bDistance);
    });
    final isLoading = questionMapNotifier.type == StateType.loading;
    return SlidingSheet(
      elevation: 8,
      cornerRadius: 16,
      controller: sheetController,
      snapSpec: SnapSpec(
        snap: true,
        snappings: [60.0, 400.0, bottomSheetHeight - 55],
        positioning: SnapPositioning.pixelOffset,
      ),


      builder: (context, state) {

        return Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(

            padding: const EdgeInsets.only(bottom: 50),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {

              final q = questions[index];
              return QuestionCard(
                title: q.title,
                text: q.text ?? "",
                avatarIcon: q.user?.avatarIcon,
                username: q.user?.username ?? "",
                onQuestionPressed: () {
                  // TODO: 質問詳細画面へ遷移できるようにする。
                  ref.read(_sheetControllerProvider).collapse();
                }, onUserPressed: () {
                  ref.read(_sheetControllerProvider).collapse();
                },

              );
            },
            itemCount: questions.length,
          ),

        );

      },
      headerBuilder: (context, state) {
        return Container(
          height: 56,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Text(
            isLoading ? "周辺の情報を取得しています.." : "周辺の質問",
            //style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
