import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  CameraPosition? cameraPosition;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(QuestionProviders.questionMapNotifier());
    _controller.future.then((value){

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

              }
            )
        ).toSet(),
        onCameraMove: (position) {
          //log("カメラが動いた position:$position");
          // NOTE: 現在のカメラの位置を記録したいだけなのでsetStateなどは呼び出さない。
          cameraPosition = position;
        },
        onLongPress: (latLng) {

        },
        onCameraIdle: () async {
          final ct = await _controller.future;
          final visibleRegion = await ct.getVisibleRegion();

          final pos = cameraPosition;
          if(pos == null) {
            return;
          }
          ref.read(QuestionProviders.questionMapNotifier().notifier).fetch(
            LatLng(pos.target.latitude, pos.target.longitude),
            visibleRegion
          );

        },



      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}