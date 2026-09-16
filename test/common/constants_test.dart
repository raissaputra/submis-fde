import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('color constants should be defined', () {
    expect(kRichBlack, isA<Color>());
    expect(kOxfordBlue, isA<Color>());
    expect(kPrussianBlue, isA<Color>());
    expect(kMikadoYellow, isA<Color>());
    expect(kDavysGrey, isA<Color>());
    expect(kGrey, isA<Color>());
    expect(BASE_IMAGE_URL, isNotEmpty);
  });

  test('text style constants should be defined', () {
    expect(kHeading5, isA<TextStyle>());
    expect(kHeading6, isA<TextStyle>());
    expect(kSubtitle, isA<TextStyle>());
    expect(kBodyText, isA<TextStyle>());
  });

  test('theme constants should be defined', () {
    expect(kTextTheme, isA<TextTheme>());
    expect(kDrawerTheme, isA<DrawerThemeData>());
    expect(kColorScheme, isA<ColorScheme>());
  });
}
