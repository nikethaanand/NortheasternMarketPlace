/*
  1. Use YLYText to solve the problem that flutter Text cannot be centered
*/

/* YLYText start ------------------------------------------------- */

import 'package:flutter/material.dart';

// Solve the problem of leading and centering on various
class YLYText extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final int maxLines;
  final double heightWeight;
  final TextOverflow overflow;
  final double textMaxWidth;
  final double textMaxHeight;
  final TextAlign textAlign;
  final Color backgroundColor;

  /// Define Text
  YLYText(
      {required this.title,
      required this.textStyle,
      this.backgroundColor = Colors.transparent,
      this.maxLines = 1,
      this.heightWeight = 1.0,
      this.overflow = TextOverflow.ellipsis,
      this.textMaxWidth = double.infinity,
      this.textMaxHeight = double.infinity,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    // Adjust size if needed
    return Container(
        color: backgroundColor,
        clipBehavior: Clip.none,
        constraints: BoxConstraints(
            maxWidth: textMaxWidth,
            minWidth: 0,
            maxHeight: textMaxWidth,
            minHeight: 0),
        child: Text(
          title,
          maxLines: maxLines,
          textAlign: textAlign,
          style: textStyle,
          overflow: overflow,
          strutStyle: StrutStyle(
            fontSize: textStyle.fontSize,
            fontWeight: textStyle.fontWeight,
            leading: 0,
            height: heightWeight,
            forceStrutHeight: true,
          ),
          textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
        ));
  }
} /* YLYText end ------------------------------------------------- */
