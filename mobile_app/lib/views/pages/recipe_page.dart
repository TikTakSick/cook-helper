import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// utils
import '../utils/page_title.dart';
import '../utils/colors.dart';

// models
import '../../models/recipe_model.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  const RecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: recipe.dishName ?? '名前がありません'),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: const SingleChildScrollView(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Gap(10),
            Gap(10),
            Text('Recipe Page Content'),
          ]),
        ));
  }
}
