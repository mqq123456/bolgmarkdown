import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ConfigViewState();
  }
}

class _ConfigViewState extends State<ConfigView> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadPath();
  }

  void loadPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    controller.text = prefs.getString("bolg_path")!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('应用设置'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration:const InputDecoration(
                    labelText: "博客文档地址",
                    hintText: "请输入文档地址",
                    prefixIcon: Icon(Icons.folder_open)),
                controller: controller,
              ),
            ),
            TextButton(
              child:const Text('保存'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("bolg_path", controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
