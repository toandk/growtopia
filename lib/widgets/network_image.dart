import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class GPNetworkImage extends StatelessWidget {
  final String url;
  final Widget? placeholder;
  final double? width, height;
  final BoxFit? fit;
  final Color? color;
  final Color? backgroundColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  const GPNetworkImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.borderRadius,
    this.color,
    this.backgroundColor,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget placeholder = this.placeholder != null
        ? SizedBox(width: width, height: height, child: this.placeholder!)
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                border: border,
                color: backgroundColor ?? GPColor.bgPrimary,
                borderRadius: borderRadius));
    return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: url.isEmpty
            ? placeholder
            : Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    border: border,
                    borderRadius: borderRadius,
                    color: backgroundColor),
                child: url.contains('.svg')
                    ? SvgPicture.network(
                        url,
                        fit: fit ?? BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      )
                    : url.contains('.json')
                        ? Lottie.network(url)
                        : CachedNetworkImage(
                            imageUrl: url,
                            fit: fit,
                            color: color,
                            errorWidget: (context, url, error) => placeholder),
              ));
  }
}
