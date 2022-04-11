import 'package:bolgmarkdown/desktop/format_markdown.dart';
import 'package:bolgmarkdown/desktop/markdown_text_input.dart';
import 'package:bolgmarkdown/desktop/markdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentView extends StatefulWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContentViewState();
  }
}

class _ContentViewState extends State<ContentView> {
  String description = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
    controller.addListener(() {
      // print(controller.text);
      _saveData();
    });
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    controller.text = prefs.getString("bolg_tmp")!;
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("bolg_tmp", controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return
      Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 1,
          child: MarkdownTextInput(
          (String value) => setState(() => description = value),
          description,
          label: 'Description',
          maxLines: null,
          actions: MarkdownType.values,
          controller: controller,
        ),
        ),
        const VerticalDivider(width: 1,color: Color.fromARGB(255, 125, 123, 122),),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child:  MarkdownWidget(
                markdownData: description, style: MarkdownWidget.kWhite),
          )
           
        ),
      ],
    );
  }
}
