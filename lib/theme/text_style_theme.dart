import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_color.dart';

TextStyle pBoldBlackTextStyle =
    GoogleFonts.montserrat(color: pBlackColor, fontWeight: bold);
TextStyle pBlackTextStyle =
    GoogleFonts.montserrat(color: pBlackColor, fontWeight: regular);
TextStyle pBoldWhiteTextStyle =
    GoogleFonts.montserrat(color: pWhiteColor, fontWeight: bold);
TextStyle pWhiteTextStyle =
    GoogleFonts.montserrat(color: pWhiteColor, fontWeight: regular);
TextStyle pDangerTextStyle =
    GoogleFonts.montserrat(color: pRedColor, fontWeight: regular);

// Font Weight

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
