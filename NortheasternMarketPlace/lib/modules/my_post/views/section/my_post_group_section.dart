import 'package:flutter/material.dart';
import 'package:gtk_flutter/ui/units/common_ui.dart';
import 'package:gtk_flutter/ui/widgets/text.dart';

// First Level Click Call Back
typedef FirstLevelClickCallBack = void Function(int firstIndex);

class MyPostGroupSectionWidget extends StatefulWidget {
  MyPostGroupSectionWidget(
      {super.key,
      required this.firstSelectString,
      required this.firstLevelSelectData,
      required this.secondLevelSelectData,
      required this.firstLevelCallBack});

  FirstLevelClickCallBack firstLevelCallBack;

  /// First level page subscript
  ValueNotifier<int> firstLevelIndex = ValueNotifier<int>(0);

  /// Second level page subscript
  ValueNotifier<int> secondLevelIndex = ValueNotifier<int>(-1);

  List<String> firstLevelSelectData;
  List<String> secondLevelSelectData;

  String firstSelectString;

  @override
  State<StatefulWidget> createState() {
    return MyPostGroupSectionWidgetState();
  }
}

class MyPostGroupSectionWidgetState extends State<MyPostGroupSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: YLYScreenWidth(),
      height: YLYAdaptor375(40),
      padding:
          EdgeInsets.only(left: YLYAdaptor375(20), right: YLYAdaptor375(20)),
      color: Color.fromARGB(212, 221, 9, 44), //Colors.blue,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          GestureDetector(
            child: YLYText(
                title: widget.firstLevelSelectData[0],
                textStyle: YLYNormalFont(14, Colors.white)),
          ),
          Container(
            color: Color.fromARGB(212, 221, 9, 44), //Colors.red,
            child: YLYText(
                title: ' > ', textStyle: YLYNormalFont(14, Colors.white)),
          ),
          Container(
            color: Color.fromARGB(212, 221, 9, 44), //Colors.yellow,
            child: PopupMenuButton(
              child: Text(widget.firstSelectString),
              itemBuilder: (context) {
                List<PopupMenuItem> menuItems = [];
                for (var i = 0; i < widget.firstLevelSelectData.length; i++) {
                  PopupMenuItem item = PopupMenuItem(
                    value: i,
                    child: Text(
                      widget.firstLevelSelectData[i],
                      style: YLYNormalFont(
                          12,
                          i == 5
                              ? Color.fromARGB(255, 170, 164, 164)
                              : Colors.black),
                    ),
                  );

                  menuItems.add(item);
                }

                return menuItems;
              },
              onSelected: (value) {
                if (widget.firstLevelCallBack != null) {
                  widget.firstLevelCallBack(value);
                }

                setState(() {
                  widget.firstSelectString = widget.firstLevelSelectData[value];
                });
              },
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: widget.secondLevelIndex,
            builder: (context, value, child) {
              return Visibility(
                visible: value >= 0 ? true : false,
                child: Container(
                  color: Color.fromARGB(212, 221, 9, 44), //Colors.red,
                  child: YLYText(
                      title: ' > ',
                      textStyle: YLYNormalFont(
                        14,
                        Colors.white,
                      )),
                ),
              );
            },
          ),
          ValueListenableBuilder<int>(
              valueListenable: widget.secondLevelIndex,
              builder: (context, value, child) {
                return Visibility(
                  visible: value >= 0 ? true : false,
                  child: Container(
                    color: Colors.amber[800], //Color.fromARGB(212, 221, 9, 44),
                    child: Text(value >= 0
                        ? widget.secondLevelSelectData[
                            widget.secondLevelIndex.value]
                        : ''),
                  ),
                );
              }),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
