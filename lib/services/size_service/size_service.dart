import 'package:flutter/widgets.dart';

class SizeService {
  final BuildContext context;
  SizeService(this.context);

  Size get size => MediaQuery.of(context).size;

  double get width => MediaQuery.of(context).size.width;

  double get height => MediaQuery.of(context).size.height;

  static const double outerPadding = 8.0;
  static const double innerPadding = 8.0;

  static const double outerHorizontalPadding = 20.0;
  static const double innerHorizontalPadding = 12.0;
  static const double innerVerticalPadding = 5.0;
  static const double outerVerticalPadding = 8.0;
  static const double separatorHeight = 10.0;
  static const double borderRadius = 12.0;
}
