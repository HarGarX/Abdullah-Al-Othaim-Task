import 'package:abdullah_al_othaim_task/src/app.dart';
import 'package:abdullah_al_othaim_task/src/core/service_locater.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  init().then((_) {
    runApp(const App());
  });
}

Future<void> init() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //hide system menu to have Full Splash Screen
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
  ]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 3)).then((_) async {
    await di.setUpLocator();
    FlutterNativeSplash.remove();
  });
  return;
}
