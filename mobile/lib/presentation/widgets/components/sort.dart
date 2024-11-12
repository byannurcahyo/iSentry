import 'package:flutter/material.dart';

class MySort extends StatelessWidget {
  final List<String> texts;
  final int selectedIndex;
  final double leftPadding;
  final double rightPadding;

  const MySort({
    super.key,
    required this.texts,
    required this.selectedIndex,
    required this.leftPadding,
    required this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 241, 244, 249),
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFe7e8eb),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(texts.length, (index) {
            return Container(
              height: 25,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: index == selectedIndex
                    ? Colors.black
                    : const Color(0xFFe7e8eb),
              ),
              child: Center(
                child: Text(
                  texts[index],
                  style: TextStyle(
                    color: index == selectedIndex ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}