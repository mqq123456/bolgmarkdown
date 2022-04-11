import 'dart:io';

import 'package:bolgmarkdown/desktop/bolg_view.dart';
import 'package:bolgmarkdown/desktop/config_view.dart';
import 'package:bolgmarkdown/desktop/format_markdown.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String? Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String? label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection? textDirection;

  /// The maximum of lines that can be display in the input
  final int? maxLines;

  /// List of action the component can handle
  final List<MarkdownType> actions;

  /// Optionnal controller to manage the input
  final TextEditingController? controller;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(
    this.onTextChanged,
    this.initialValue, {
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.maxLines = 10,
    this.actions = const [
      MarkdownType.bold,
      MarkdownType.italic,
      MarkdownType.title,
      MarkdownType.link,
      MarkdownType.list
    ],
    this.controller,
  });

  @override
  _MarkdownTextInputState createState() =>
      _MarkdownTextInputState(controller ?? TextEditingController());
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final TextEditingController _controller;
  TextSelection textSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);

  _MarkdownTextInputState(this._controller);

  void _saveFile() async {
    var fileNameController = new TextEditingController();
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title:const Text('请输入文件名称'),
            content: CupertinoTextField(
              controller: fileNameController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:const Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    String fileName = fileNameController.text;
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String path = prefs.getString("bolg_path")!;
                    File file = File('$path/$fileName.md');
                    IOSink sink = file.openWrite(mode: FileMode.append);
                    sink.write(_controller.text);
                    sink.close();
                    //
                    BotToast.showText(text: "保存成功！");
                  } catch (e) {
                    BotToast.showText(text: e.toString());
                  }
                },
                child:const Text('确定'),
              ),
            ],
          );
        });
  }

  void onTap(MarkdownType type, {int titleSize = 1}) {
    if (type == MarkdownType.clean) {
      _controller.clear();
      return;
    }
    if (type == MarkdownType.save) {
      _saveFile();
      return;
    }
    if (type == MarkdownType.files) {
       Navigator.push(
        context,MaterialPageRoute(builder: (context) =>const BolgView()),
      );
      return;
    }
    if (type == MarkdownType.config) {
      // 
      Navigator.push(
        context,MaterialPageRoute(builder: (context) => const ConfigView()),
      );
      return;
    }
    final basePosition = textSelection.baseOffset;
    var noTextSelected =
        (textSelection.baseOffset - textSelection.extentOffset) == 0;

    final result = FormatMarkdown.convertToMarkdown(type, _controller.text,
        textSelection.baseOffset, textSelection.extentOffset,
        titleSize: titleSize);
    _controller.value = _controller.value.copyWith(
        text: result.data,
        selection:
            TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(
          offset: _controller.selection.end - result.replaceCursorIndex);
    }
  }

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      if (_controller.selection.baseOffset != -1)
        textSelection = _controller.selection;
      widget.onTextChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: [
      SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.actions.map((type) {
            return type == MarkdownType.title
                ? ExpandableNotifier(
                    child: Expandable(
                      key: const Key('H#_button'),
                      collapsed: ExpandableButton(
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'H',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      expanded: Container(
                        color: Colors.white10,
                        child: Row(
                          children: [
                            for (int i = 1; i <= 6; i++)
                              InkWell(
                                key: Key('H${i}_button'),
                                onTap: () =>
                                    onTap(MarkdownType.title, titleSize: i),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'H$i',
                                    style: TextStyle(
                                        fontSize: (18 - i).toDouble(),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ExpandableButton(
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.close,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    key: Key(type.key),
                    onTap: () => onTap(type),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(type.icon),
                    ),
                  );
          }).toList(),
        ),
      ),
      const Divider(
        height: 1.0,
        indent: 0.0,
        color: Color.fromARGB(255, 125, 123, 122),
      ),
      Expanded(
          child: TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: widget.maxLines,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => widget.validators!(value),
              cursorColor: Theme.of(context).primaryColor,
              textDirection: widget.textDirection,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "请输入...",
                hintStyle: TextStyle(color: Color.fromRGBO(63, 61, 86, 0.5)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ))),
    ]));
  }
}
