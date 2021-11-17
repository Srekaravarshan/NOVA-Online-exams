import 'package:exam/constants/constants.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';

Widget classCard(
    {required int i,
    required String title,
    required String description,
    required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: colors[i % colors.length],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white)),
        addVerticalSpace(40),
        Text(description,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(color: Colors.white70))
      ],
    ),
  );
}
