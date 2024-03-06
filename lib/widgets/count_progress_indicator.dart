import 'package:flutter/material.dart';

class CountProgressIndicator extends StatelessWidget {
  final int totalCount, current;
  const CountProgressIndicator(
      {super.key, required this.totalCount, required this.current});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500),
            color: current == index ? Colors.grey.shade500 : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 3),
      ),
    );
  }
}
