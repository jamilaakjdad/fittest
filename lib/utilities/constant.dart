import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

//Sizes
const double kSizeBottomNavigationBarHeight = 70.0;
const double kSizeBottomNavigationBarIconHeight = 30.0;

//Colors
const Color kColorBNBActiveTitleColor = Color.fromARGB(255, 66, 66, 66);
const Color kColorBNBDeactiveTitleColor = Color.fromARGB(255, 144, 144, 144);
const Color kColorBNBBackground = Colors.grey;

//auth
const double defpaultPadding = 16.0;
const Duration defaultDuration = Duration(milliseconds: 300);

//details pages
double screenHeight = Get.context!.height;
double sizeImg = screenHeight / 2.41;

// Set your env [dev, prod, local]
const ENV = "prod";

const release_version = "1.0.6";
// Server used for dev , prod or local
const HOST = ENV == "dev" ? "https://fithouse.pythonanywhere.com" :
ENV == "prod" ? "https://jyssr.pythonanywhere.com" : "http://192.168.1.35:8000";

const currentVersion = 2;