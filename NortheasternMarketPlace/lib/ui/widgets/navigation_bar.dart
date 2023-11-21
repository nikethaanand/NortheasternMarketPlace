import 'package:flutter/material.dart';
import 'package:gtk_flutter/ui/units/common_ui.dart';
import 'package:gtk_flutter/ui/widgets/text.dart';

class YLYNavigationBarWidget extends StatefulWidget {
  double barHeight;
  double barWidth;
  Color? backgroundColor;
  String mainTitle;
  TextStyle titleStyle;

  YLYNavigationBarWidget(
      {super.key,
      required this.barHeight,
      required this.barWidth,
      this.backgroundColor,
      required this.mainTitle,
      required this.titleStyle});

  @override
  State<StatefulWidget> createState() {
    return YLYNavigationBarWidgetState();
  }
}

class YLYNavigationBarWidgetState extends State<YLYNavigationBarWidget> {
  Color? barColor;

  @override
  Widget build(BuildContext context) {
    widget.backgroundColor == null
        ? barColor = Colors.white
        : barColor = widget.backgroundColor;

    return Container(
      width: widget.barWidth,
      height: widget.barHeight + YLYSizeAdaptor().statusBarHeight_safe(),
      alignment: Alignment.center,
      color: barColor!,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            height: YLYSizeAdaptor().statusBarHeight_safe(),
          ),
          Container(
            color: Colors.transparent,
            height: widget.barHeight,
            alignment: Alignment.center,
            child:
                YLYText(title: widget.mainTitle, textStyle: widget.titleStyle),
          ),
        ],
      ),
    );
  }
}
