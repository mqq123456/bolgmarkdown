import 'dart:io';

import 'package:bolgmarkdown/desktop/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  //一个简单的答案是，如果 Flutter 在调用 runApp 之前需要调用原生代码
  WidgetsFlutterBinding.ensureInitialized();
   _initDesktop();
  runApp(MyApp());
}
/// 解决桌面显示问题
void _initDesktop() async {
  if (!(Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
    return;
  }
  // Must add this line.
  await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async{
    await windowManager.setSize(const Size(1200, 800));
    await windowManager.center();
    await windowManager.show();
  });

}
