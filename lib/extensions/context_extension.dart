import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;
  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;

  ThemeData get theme => Theme.of(this);
}

extension NumberExtension on BuildContext {
  double get lowHeightValue => dynamicHeight(0.01);
  double get mediumHeightValue => dynamicHeight(0.03);
  double get highHeightValue => dynamicHeight(0.05);
  double get lowWidthValue => dynamicWidth(0.01);
  double get mediumWidthValue => dynamicWidth(0.03);
  double get highWidthValue => dynamicWidth(0.05);
}

extension PaddingExtension on BuildContext {
  EdgeInsets dynamicVerticalPadding(double val) =>
      EdgeInsets.symmetric(vertical: dynamicHeight(val));
  EdgeInsets dynamicHorizontalPadding(double val) =>
      EdgeInsets.symmetric(vertical: dynamicWidth(val));
  EdgeInsets get paddingAllLow => EdgeInsets.all(dynamicHeight(0.01));
  EdgeInsets get paddingLowHorizontal =>
      EdgeInsets.symmetric(horizontal: dynamicHeight(0.01));
  EdgeInsets get paddingMediumHorizontal =>
      EdgeInsets.symmetric(horizontal: dynamicHeight(0.02));
  EdgeInsets get paddingHighHorizontal =>
      EdgeInsets.symmetric(horizontal: dynamicHeight(0.03));
  EdgeInsets get paddingLowVertical =>
      EdgeInsets.symmetric(horizontal: dynamicHeight(0.01));
  EdgeInsets get paddingLowMediumVertical =>
      EdgeInsets.symmetric(vertical: dynamicHeight(0.015));
  EdgeInsets get paddingMediumVertical =>
      EdgeInsets.symmetric(vertical: dynamicHeight(0.02));
  EdgeInsets get paddingMediumMediumVertical =>
      EdgeInsets.symmetric(vertical: dynamicHeight(0.025));
  EdgeInsets get paddingHighVertical =>
      EdgeInsets.symmetric(vertical: dynamicHeight(0.04));
}

extension EmptyWidget on BuildContext {
  Widget get emptyWidgetHeight =>
      SizedBox(height: dynamicHeight(lowHeightValue));
}
