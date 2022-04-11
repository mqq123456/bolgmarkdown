import 'dart:convert';
import 'dart:io';

import 'package:bolgmarkdown/desktop/markdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BolgView extends StatefulWidget {
  const BolgView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BolgViewState();
  }
}

class _BolgViewState extends State<BolgView> {
  @override
  void initState() {
    super.initState();
    // 加载本地数据
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString("bolg_path")!;
    Directory tempDir = Directory(path);
    List<FileSystemEntity> list = await tempDir.list().toList();
    for (int i = 0; i < list.length; i++) {
      FileSystemEntity entity = list[i];
      FileSystemEntityType type = FileSystemEntity.typeSync(entity.path);
      if (type == FileSystemEntityType.file) {
        String name = entity.path.split("/").last;
        items.add(name);
      }
    }
    items.sort();
    items = items.reversed.toList();
    setState(() {});
  }

  void readFile(int index) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString("bolg_path")!;
    File file = File(path + "/" + items[index]);
    issueDesHtml = await file.readAsString(encoding: utf8);
    setState(() {

    });
  }

  List<String> items = [];
  String issueDesHtml = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("我的博客"),
      ),
      body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 200,
          child: ListView.separated(
            //排列方向 垂直和水平
            scrollDirection: Axis.vertical,
            //分割线构建器
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1.0,
                indent: 16.0,
                endIndent: 0.0,
                color: Color.fromARGB(255, 125, 123, 122),);
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
                onTap: () {
                  readFile(index);
                },
              );
            },
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child:  MarkdownWidget(
                markdownData: issueDesHtml, style: MarkdownWidget.kWhite),
          ),
        )
      ],
      )
    );
  }
}
