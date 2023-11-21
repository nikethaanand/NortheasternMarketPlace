import 'package:flutter/material.dart';
import 'package:gtk_flutter/modules/my_post/models/my_post_model.dart';
import 'package:gtk_flutter/ui/units/common_ui.dart';
import 'package:gtk_flutter/ui/widgets/text.dart';

class MyPostEditPostCellInfo {
  int index = -1;
  String cellType = '0'; // cell type 1:TextField; 2:PopupMenuButton; 3:button
  String title = '';
  String hint = '';
  String value = '';

  List<String> sectionList = [];
  String sectionString = '     --     ';

  String buttonContent = '';
  Color buttonColor = Colors.transparent;

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  MyPostEditPostCellInfo(this.title, this.hint, this.cellType, this.sectionList,
      this.buttonContent);
}

// Edit photo click callback
typedef EditPhotosClickCallBack = void Function();

// Save information
typedef MarkAsSoldClickCallBack = void Function(MyPostModel currentPostModel);

// Delete information
typedef DeleteClickCallBack = void Function();

class MyPostEditPostWidget extends StatefulWidget {
  MyPostEditPostWidget(
      {super.key,
      required this.editPhotosCallBack,
      required this.markAsSoldClickCallBack,
      required this.deleteClickCallBack});

  /// current model
  MyPostModel currentPostModel = MyPostModel();

  EditPhotosClickCallBack editPhotosCallBack;

  MarkAsSoldClickCallBack markAsSoldClickCallBack;

  DeleteClickCallBack deleteClickCallBack;

  /// create cell data
  List<MyPostEditPostCellInfo> cellInfoData = [
    MyPostEditPostCellInfo('Username', 'Enter your username', '0', [], ''),
    MyPostEditPostCellInfo(
        'Product Name', 'Enter your product name', '0', [], ''),
    MyPostEditPostCellInfo('Description', 'Enter a description', '0', [], ''),
    MyPostEditPostCellInfo(
        'Pickup address', 'Enter pickup address', '0', [], ''),
    MyPostEditPostCellInfo('Starting price', '\$', '0', [], ''),
    MyPostEditPostCellInfo(
        'Category',
        '',
        '1',
        [
          "Furniture",
          "Books",
          "House Appliances",
          "Sports Equipment",
          "Others"
        ],
        ''),
    MyPostEditPostCellInfo(
        'Condition', '', '1', ["New", "Like New", "Good", "Acceptable"], ''),
    MyPostEditPostCellInfo('Confirm photos', '', '2', [], 'UploadPhotos'),
    MyPostEditPostCellInfo('Confirm photos', '', '2', [], 'Mark as Sold'),
    MyPostEditPostCellInfo('Confirm photos', '', '2', [], 'Delete'),
  ];

  @override
  State<StatefulWidget> createState() {
    return MyPostEditPostWidgetState();
  }
}

class MyPostEditPostWidgetState extends State<MyPostEditPostWidget> {
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
      MyPostEditPostCellInfo info = widget.cellInfoData[i];
      info.index = i;

      info.buttonColor = (info.buttonContent != 'Delete'
          ? Colors.transparent
          : Colors.red[300])!;

      SliverToBoxAdapter cellAdapter = SliverToBoxAdapter(
        child: getTextCell(info),
      );

      list.add(cellAdapter);
    }

    return list;
  }

  Container getTextCell(MyPostEditPostCellInfo info) {
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
            color: info.buttonColor,
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
            decoration: BoxDecoration(
              color: info.buttonColor,
              border: Border.all(color: Colors.black, width: 1),
            ),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                switch (info.index) {
                  case 6:
                    {
                      if (widget.editPhotosCallBack != null) {
                        widget.editPhotosCallBack();
                      }
                      break;
                    }
                  case 7:
                    {
                      if (widget.markAsSoldClickCallBack != null) {
                        widget.markAsSoldClickCallBack(widget.currentPostModel);
                      }
                      break;
                    }
                  case 8:
                    {
                      if (widget.deleteClickCallBack != null) {
                        widget.deleteClickCallBack();
                      }
                      break;
                    }

                  default:
                    {
                      ;
                    }
                }
              },
              child: YLYText(
                  title: info.buttonContent,
                  textStyle: YLYNormalFont(14, Colors.black)),
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
