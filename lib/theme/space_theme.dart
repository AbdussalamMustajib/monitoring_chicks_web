import 'package:flutter/material.dart';

Widget pSpaceMini(context) {
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width * 0.01,
    width: width * 0.01,
  );
}

Widget pSpaceSmall(context) {
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width * 0.02,
    width: width * 0.02,
  );
}

Widget pSpaceMedium(context) {
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width * 0.04,
    width: width * 0.04,
  );
}

Widget pSpaceBig(context) {
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width * 0.08,
    width: width * 0.08,
  );
}
