import 'package:bolgmarkdown/desktop/app.dart';
import 'package:flutter/material.dart';

void main() {
  //一个简单的答案是，如果 Flutter 在调用 runApp 之前需要调用原生代码
  WidgetsFlutterBinding.ensureInitialized();
  // _initDesktop();
  runApp(MyApp());
}