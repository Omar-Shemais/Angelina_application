import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimensions {
  static double getHeight(
    context,
    int fraction, {
    bool removeAppBarHeight = true,
  }) {
    final mediaQuery = MediaQuery.of(context);
    if (removeAppBarHeight) {
      return (mediaQuery.size.height -
              AppBar().preferredSize.height -
              mediaQuery.padding.top) /
          fraction;
    }
    return mediaQuery.size.height / fraction;
  }

  static double getWidth(context, int fraction) {
    return MediaQuery.of(context).size.width / fraction;
  }
}

extension DimensionsExtension on num {
  double get height {
    return h;
  }

  double get width {
    return w;
  }
}
