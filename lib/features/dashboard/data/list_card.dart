import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/common/entities/card.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

List<CardData> listCard = [
  CardData(
    image: 'assets/images/dashboard/info1.png',
    color: AppPalette.gradient1,
    onTap: () {
      // Handle card tap
      debugPrint('Tapped: Info 1');
    },
  ),
  CardData(
    image: 'assets/images/dashboard/info2.png',
    color: AppPalette.gradient1,
    onTap: () {
      // Handle card tap
      debugPrint('Tapped: Info 2');
    },
  ),
  CardData(
    image: 'assets/images/dashboard/info3.png',
    color: AppPalette.gradient1,
    onTap: () {
      // Handle card tap
      debugPrint('Tapped: Info 3');
    },
  ),
];
