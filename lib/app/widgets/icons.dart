import 'package:flutter/material.dart';
import 'package:todo_app/app/core/values/app_colors.dart';
import 'package:todo_app/app/core/values/app_icons.dart';

List<Icon> getIcons() => const [
      Icon(IconData(AppIcons.personIcon, fontFamily: "MaterialIcons"),
          color: AppColors.purple),
      Icon(IconData(AppIcons.workIcon, fontFamily: "MaterialIcons"),
          color: AppColors.pink),
      Icon(IconData(AppIcons.movieIcon, fontFamily: "MaterialIcons"),
          color: AppColors.green),
      Icon(IconData(AppIcons.sportIcon, fontFamily: "MaterialIcons"),
          color: AppColors.yellow),
      Icon(IconData(AppIcons.travelIcon, fontFamily: "MaterialIcons"),
          color: AppColors.deepPink),
      Icon(IconData(AppIcons.shopIcon, fontFamily: "MaterialIcons"),
          color: AppColors.lightBlue),
    ];
