import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MapState();
  }
}

class MapState extends ConsumerState {
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition? _cameraPosition;
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
            zoom: _cameraPosition?.zoom ?? 14
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
      body: GoogleMap(
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
          _cameraPosition = position;
        },
        onLongPress: (latLng) {

        },
        onCameraIdle: () async {
          final ct = await _controller.future;
          final visibleRegion = await ct.getVisibleRegion();

          final pos = _cameraPosition;
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
    );
  }

  Future onQuestionMarkerTapped(Question q) async {
    log("質問が選択されました:${q.title}");
  }
}