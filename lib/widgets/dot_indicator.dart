import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;
  final Function()? onTap;
  const DotIndicator({Key? key, required this.isActive, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: isActive ? 10 : 8.0,
          width: isActive ? 12 : 8.0,
          decoration: BoxDecoration(
            boxShadow: [
              isActive
                  ? BoxShadow(
                      color: const Color(0XFF2FB7B2).withOpacity(0.72),
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                    )
                  : const BoxShadow(
                      color: Colors.transparent,
                    )
            ],
            shape: BoxShape.circle,
            color: isActive ? const Color(0XFF6BC4C9) : const Color(0XFFEAEAEA),
          ),
        ),
      ),
    );
  }
}
