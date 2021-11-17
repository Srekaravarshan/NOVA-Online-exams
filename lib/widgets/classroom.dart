import 'package:exam/constants/constants.dart';
import 'package:flutter/material.dart';

Widget subjectCard(
    {required int i, required String title, required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: colors[i % colors.length],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Text(title,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: Colors.white)),
  );
}
