import 'package:flutter/material.dart';

import '../enums/LogoSizeType.dart';

class JibbapLogoWidget extends StatelessWidget {
  LogoSizeType size;
  JibbapLogoWidget({super.key, this.size = LogoSizeType.big});

  @override
  Widget build(BuildContext context) {
    double width, height, iconSize, fontSize, offset;
    if (size == LogoSizeType.big) {
      width = 200;
      height = 200;
      iconSize = 150;
      fontSize = 30;
      offset = -20;
    } else if (size == LogoSizeType.middle) {
      width = 150;
      height = 150;
      iconSize = 100;
      fontSize = 25;
      offset = -15;
    } else if (size == LogoSizeType.small) {
      width = 100;
      height = 100;
      iconSize = 60;
      fontSize = 15;
      offset = -10;
    } else {
      width = 130;
      height = 40;
      iconSize = 25;
      fontSize = 0;
      offset = 0;
    }
    return size == LogoSizeType.tiny
        ? Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF7CC144),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home_rounded,
                  size: iconSize,
                  color: Colors.white,
                ),
                const Text(
                  'Jibbap',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ))
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFF7CC144),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_rounded,
                  size: iconSize,
                  color: Colors.white,
                ),
                Transform.translate(
                  offset: Offset(0, offset),
                  child: Text(
                    'Jibbap',
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          );
  }
}
