// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';



const defaultPadding = 16.0;
const default32 = 32.0;
const default24 = 24.0;
const default16 = 16.0;
const default8 = 8.0;
const default4 = 4.0;

const themeColor1 = Color(0xFF81D4FA);
const themeColor3 = Color(0xFF64B5F6);
const themeColor2 = Color(0xFFE3F2FD);
const themeColor = Color(0xFFBBDEFB);
const Color bluebland = Color(0XFF51CDF5);
const Color bluedark = Color(0XFF0D47A1);
const Color bluedark1 = Color(0XFF0F156D);
const Color redbland = Color(0XFFFF6E40);
const Color red = Color(0XFFEF5350);
const Color redColor = Color(0XFFF43F5E);
const Color lightRedColor = Color(0XFFFF3D00);
const Color grayColor = Color.fromARGB(255, 159, 164, 166);
const Color lightGrayColor = Color(0XFFEEEEEE);
const Color blackColor = Color(0XFF212121);
const Color lightblue = Color(0XFF64B5F6);
const Color orange = Color(0XFFFFA000);
const Color orangeyellow = Color(0XFFFFFF00);
const Color lightorange = Color(0XFFFFECB3);
const Color lightorange1 = Color(0XFFFFCA28);
const Color green = Color(0XFF22C55E);
const Color lightgreen = Color(0XFFCCFF90);
const Color violet = Color(0XFFE040FB);
const Color lightviolet = Color(0XFFEA80FC);
const Color lemonyellow = Color(0XFFC0CA33);
const Color lightlemonyellow = Color(0XFFE6EE9C);
const Color powderblue = Color(0XFF00B8D4);
const Color lightpowderblue = Color(0XFF18FFFF);
const Color grey1 = Color(0XFF033544);
const Color grey = Color(0XFF033544);

const styleHintText = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const styleHintText1 = TextStyle(
    color: Color.fromARGB(255, 159, 164, 166),
    fontWeight: FontWeight.w400,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const styleHeadingRow = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w900,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style15grey = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w900,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style10grey = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w800,
    fontSize: 10,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style13grey = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w800,
    fontSize: 13,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style15Blue = TextStyle(
    color: bluebland,
    fontWeight: FontWeight.w900,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style15White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style18Blue = TextStyle(
    color: Color(0xFF51CDF5),
    fontWeight: FontWeight.w900,
    fontSize: 18,
    decoration: TextDecoration.none);

const style20White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 20,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style22White = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style25White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 25,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style12White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 12,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style10White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style30White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 30,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const style20 = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
var style20blue = TextStyle(
    color: Colors.blue.shade400,
    fontWeight: FontWeight.w900,
    fontSize: 20,
    decoration: TextDecoration.none);
const stylelarge = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w800,
    fontSize: 25,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);

const styleWarning = TextStyle(
    color: bluedark1,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const styleBottomCard = TextStyle(
    color: bluebland,
    fontWeight: FontWeight.w800,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const styleDataTable = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.none);
const styleDataTable1 = TextStyle(
    color: grey1,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    fontFamily: 'Inter',
    decoration: TextDecoration.underline);

var decoratedCircular8White = const BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(8)),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(1.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0,
    ),
  ],
);

var decoratedCircular20White = const BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(20)),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(1.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0,
    ),
  ],
);

var decoratedCircular30 = const BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(30)),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(1.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0,
    ),
  ],
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF4CB1F1), Color(0xFF4FC5F3), Color(0xFF53D9F6)],
  ),
);
var decoratedBlue = const BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [Color(0xFF53DCF6), Color(0xFF4AAEEF)],
  ),
);

var decoratedRed = const BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [Color(0xFFF6B553), Color(0xFFEF4A4A)],
  ),
);
var decoratedGrey = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    border: Border.all(color: const Color(0xFFD1D1D6)),
    color: const Color(0xFF787880).withOpacity(0.16));

var decoratedGradient = (List<Color> color) => BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.5, 1.0],
        colors: color,
      ),
    );

var decoratedCircular20Blue = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    border: Border.all(color: const Color(0XFF51C6F4), width: 2));
var greyBackgroundCircular = (int circular) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(circular.toDouble())),
      color: const Color(0xFFF5F5F5),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(1.0, 2.0),
          blurRadius: 2.0,
          spreadRadius: 2.0,
        ),
      ],
    );

var decoratedBoder = BoxDecoration(border: Border.all(color: Colors.grey));

class Const {
  Const._();


  //Message
  static const int messageError = 2;
  static const int messageSuccess = 1;

 
}
