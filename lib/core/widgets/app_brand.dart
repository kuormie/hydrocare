import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_assets.dart';

class AppBrand extends StatelessWidget {
  final double height;

  const AppBrand({super.key, this.height = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.textLogo,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
