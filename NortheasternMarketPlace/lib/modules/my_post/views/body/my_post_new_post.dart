import 'package:flutter/material.dart';
import 'package:gtk_flutter/modules/my_post/models/my_post_model.dart';
import 'package:gtk_flutter/ui/units/common_ui.dart';
import 'package:gtk_flutter/ui/widgets/text.dart';

class MyPostNewPostCellInfo {
  int index = -1;
  String cellType = '0'; // cell type 1:TextField; 2:PopupMenuButton; 3:button
  String title = '';
  String hint = '';
  String value = '';

  List<String> sectionList = [];
  String sectionString = '     --     ';

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  MyPostNewPostCellInfo(this.title, this.hint, this.cellType, this.sectionList);
}

/// Upload photo click callback
typedef UploadPhotosClickCallBack = void Function();

class MyPostNewPostWidget extends StatefulWidget {
  MyPostNewPostWidget({super.key, required this.uploadPhotosCallBack});

  /// current model
  MyPostModel currentPostModel = MyPostModel();

  UploadPhotosClickCallBack uploadPhotosCallBack;

  /// create cell data
  List<MyPostNewPostCellInfo> cellInfoData = [
    MyPostNewPostCellInfo('Username', 'Enter your username', '0', []),
    MyPostNewPostCellInfo('Product Name', 'Enter your product name', '0', []),
    MyPostNewPostCellInfo('Description', 'Enter a description', '0', []),
    MyPostNewPostCellInfo('Pickup address', 'Enter pickup address', '0', []),
    MyPostNewPostCellInfo('Starting price', '\$', '0', []),
    MyPostNewPostCellInfo('Category', '', '1', [
      "Furniture",
      "Books",
      "House Appliances",
      "Sports Equipment",
      "Others"
    ]),
    MyPostNewPostCellInfo(
        'Condition', '', '1', ["New", "Like New", "Good", "Acceptable"]),
    MyPostNewPostCellInfo('Confirm photos', 'UploadPhotos', '2', []),
  ];

  @override
  State<StatefulWidget> createState() {
    return MyPostNewPostWidgetState();
  }
}

class MyPostNewPostWidgetState extends State<MyPostNewPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: getSliversList(),
      ),
    );
  }

  List<Widget> getSliversList() {
    List<Widget> list = [];

    for (var i = 0; i < widget.cellInfoData.length; i++) {
      MyPostNewPostCellInfo info = widget.cellInfoData[i];
      info.index = i;

      SliverToBoxAdapter cellAdapter = SliverToBoxAdapter(
        child: getTextCell(info),
      );

      list.add(cellAdapter);
    }

    return list;
  }

  Container getTextCell(MyPostNewPostCellInfo info) {
    Container? subContent;

    print('index = ${info.index} , type = ${info.cellType}');

    switch (int.parse(info.cellType)) {
      case 0:
        {
          subContent = Container(
            padding: EdgeInsets.only(
                left: YLYAdaptor375(16), right: YLYAdaptor375(16)),
            width: YLYAdaptor375(220),
            height: YLYAdaptor375(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius:
                    BorderRadius.all(Radius.circular(YLYAdaptor375(20)))),
            child: TextField(
              controller: info.controller,
              focusNode: info.focusNode,
              decoration: InputDecoration(
                hintText: info.hint,
                border: InputBorder.none,
              ),
              onTapOutside: (event) {
                info.focusNode.unfocus();
              },
              onSubmitted: (value) {
                info.value = value;
              },
            ),
          );

          break;
        }
      case 1:
        {
          List<PopupMenuItem> menuItems = [];
          for (var i = 0; i < info.sectionList.length; i++) {
            PopupMenuItem item = PopupMenuItem(
              value: i,
              child: Text(
                info.sectionList[i],
                style: YLYNormalFont(12, Colors.black),
              ),
            );

            menuItems.add(item);
          }

          subContent = Container(
            height: YLYAdaptor375(40),
            alignment: Alignment.center,
            color: Colors.transparent,
            child: PopupMenuButton(
              child: Text(info.sectionString),
              itemBuilder: (context) {
                return menuItems;
              },
              onSelected: (value) {
                setState(() {
                  info.sectionString = info.sectionList[value];
                });
              },
            ),
          );

          break;
        }
      case 2:
        {
          subContent = Container(
            height: YLYAdaptor375(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: GestureDetector(
              onTap: () {
                if (widget.uploadPhotosCallBack != null) {
                  widget.uploadPhotosCallBack();
                }
              },
              child: YLYText(
                  title: info.hint, textStyle: YLYNormalFont(14, Colors.black)),
            ),
          );

          break;
        }
      default:
        {
          subContent = Container();
        }
    }

    return Container(
      color: Colors.transparent,
      width: YLYScreenWidth(),
      height: YLYAdaptor375(50),
      padding: EdgeInsets.only(
          left: YLYAdaptor375(20),
          right: YLYAdaptor375(20),
          top: YLYAdaptor375(5),
          bottom: YLYAdaptor375(5)),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          YLYText(
              title: info.title, textStyle: YLYNormalFont(14, Colors.black)),
          Expanded(child: Container()),
          subContent,
        ],
      ),
    );
  }
}
