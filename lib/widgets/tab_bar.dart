import 'package:flutter/material.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';

class MJTabbar extends StatelessWidget {
  final List<String> titles;
  final int selectedIndex;
  final void Function(int index) onChangeIndex;
  const MJTabbar(
      {Key? key,
      required this.titles,
      required this.selectedIndex,
      required this.onChangeIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: titles
          .asMap()
          .entries
          .map((entry) => Expanded(
                child: InkWell(
                    onTap: () => onChangeIndex(entry.key),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 44,
                          child: Center(
                            child: Text(
                              entry.value,
                              style: textStyle(GPTypography.fontButton)
                                  ?.mergeColor(selectedIndex == entry.key
                                      ? GPColor.contentPrimary
                                      : GPColor.contentSecondary),
                            ),
                          ),
                        ),
                        Container(
                            height: 2,
                            color: selectedIndex == entry.key
                                ? GPColor.functionAccentWorkPrimary
                                : GPColor.bgPrimary)
                      ],
                    )),
              ))
          .toList(),
    );
  }
}
