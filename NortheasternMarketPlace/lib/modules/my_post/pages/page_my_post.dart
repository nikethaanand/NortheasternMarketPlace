/*import 'package:flutter/material.dart';
import 'package:gtk_flutter/modules/my_post/views/body/my_post_edit_post.dart';
import 'package:gtk_flutter/modules/my_post/views/body/my_post_new_post.dart';
// import 'package:gtk_flutter/modules/my_post/views/body/my_post_order_history.dart';
// import 'package:gtk_flutter/modules/my_post/views/body/my_post_selling_items.dart';
// import 'package:gtk_flutter/modules/my_post/views/body/my_post_sold_items.dart';
import 'package:gtk_flutter/modules/my_post/views/body/my_post_upload_photos.dart';
import 'package:gtk_flutter/modules/my_post/views/section/my_post_group_section.dart';
import 'package:gtk_flutter/navbar_widget.dart';
import 'package:gtk_flutter/ui/units/common_ui.dart';
import 'package:gtk_flutter/ui/widgets/navigation_bar.dart';

/// navigation bar title
const String kNavigationBarTitle = 'Northeastern Market Place';

class MyPostPage extends StatefulWidget {
  MyPostPage({super.key});

  YLYNavigationBarWidget? naviBar;

  MyPostGroupSectionWidget? sectionBar;

  /// select index
  ValueNotifier<int> changeBodyIndex = ValueNotifier<int>(0);

  /// latest index
  int latestBodyIndex = 0;

  List<String> firstSelectionData = [
    "New Post",
    "Edit My Post",
    "Sold Items",
    "Selling Items",
    "Disabled Items",
    "Exit"
  ];

  List<String> secondSelectionData = ["Upload Photos"];

  // body
  MyPostNewPostWidget? newPostWidget;
  MyPostEditPostWidget? editPostWidget;
  // MyPostSellingItemsWidget? sellingItemsWidget;
  // MyPostSoldItemsWidget? soldItemsWidget;
  // MyPostOrderHistoryWidget? orderHistoryWidget;
  MyPostUploadPhotosWidget? uploadPhotosWidget;

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    YLYSizeAdaptor.prepareConfiguration(mediaQuery);

    initSubWidgets();

    return Scaffold(
      body: Container(
        color: Colors.green,
        width: YLYScreenWidth(),
        height: YLYScreenHeight(),
        child: Flex(
          direction: Axis.vertical,
          children: [
            widget.naviBar!,
            widget.sectionBar!,
            ValueListenableBuilder(
              valueListenable: widget.changeBodyIndex,
              builder: (context, value, child) {
                return Expanded(child: getBody(value));
              },
            ),
          ],
        ),
      ),
      //navigation bar in the bottom
      bottomNavigationBar: NavBar(),
    );
  }

  /// Navigation
  YLYNavigationBarWidget getNavigationbar() {
    return YLYNavigationBarWidget(
      barHeight: YLYAdaptor375(44),
      barWidth: YLYScreenWidth(),
      backgroundColor: Color.fromARGB(212, 221, 9, 44), //Colors.red,
      mainTitle: kNavigationBarTitle,
      titleStyle: YLYNormalFont(22, Colors.white),
    );
  }

  /// Group title
  MyPostGroupSectionWidget getSectionTitleBar() {
    return MyPostGroupSectionWidget(
      firstSelectString: widget.firstSelectionData[0],
      firstLevelSelectData: widget.firstSelectionData,
      secondLevelSelectData: widget.secondSelectionData,
      firstLevelCallBack: (firstIndex) {
        if (firstIndex == 5) {
          // TODO: Handle exit logic
          print('TODO: Handle exit logic');
        } else {
          setState(() {
            widget.changeBodyIndex.value = firstIndex;
            widget.sectionBar!.secondLevelIndex.value = -1;
          });
        }
      },
    );
  }

  MyPostNewPostWidget getNewPostWidget() {
    return MyPostNewPostWidget(
      uploadPhotosCallBack: () {
        widget.changeBodyIndex.value = 5;
        widget.sectionBar!.secondLevelIndex.value = 0;
      },
    );
  }

  MyPostEditPostWidget getEditPostWidget() {
    return MyPostEditPostWidget(
      editPhotosCallBack: () {
        widget.changeBodyIndex.value = 5;
        widget.sectionBar!.secondLevelIndex.value = 0;
      },
      markAsSoldClickCallBack: (currentPostModel) {
        // TODO: save data model
        print('TODO: save data model');
      },
      deleteClickCallBack: () {
        // TODO: delete data model
        print('TODO: delete data model');
      },
    );
  }

  // MyPostSellingItemsWidget getSellingItemsWidget() {
  //   return MyPostSellingItemsWidget();
  // }

  // MyPostSoldItemsWidget getSoldItemsWidget() {
  //   return MyPostSoldItemsWidget();
  // }

  // MyPostOrderHistoryWidget getOrderHistoryWidget() {
  //   return MyPostOrderHistoryWidget();
  // }

  MyPostUploadPhotosWidget getUploadPhotosWidget() {
    return MyPostUploadPhotosWidget();
  }

  /// Body Context
  Widget getBody(int index) {
    switch (index) {
      case 0:
        {
          return widget.newPostWidget!;
        }
      case 1:
        {
          return widget.editPostWidget!;
        }
      // case 2:
      //   {
      //     return widget.sellingItemsWidget!;
      //   }
      // case 3:
      //   {
      //     return widget.soldItemsWidget!;
      //   }
      // case 4:
      //   {
      //     return widget.orderHistoryWidget!;
      //   }
      case 5:
        {
          return widget.uploadPhotosWidget!;
        }

      default:
        {
          return widget.newPostWidget!;
        }
    }
  }

  /// Initialization module
  void initSubWidgets() {
    print('initSubWidgets');
    widget.naviBar ??= getNavigationbar();
    widget.sectionBar ??= getSectionTitleBar();
    widget.newPostWidget ??= getNewPostWidget();
    widget.editPostWidget ??= getEditPostWidget();
    // widget.sellingItemsWidget ??= getSellingItemsWidget();
    // widget.soldItemsWidget ??= getSoldItemsWidget();
    // widget.orderHistoryWidget ??= getOrderHistoryWidget();
    widget.uploadPhotosWidget ??= getUploadPhotosWidget();
  }
}
*/