import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    required this.url,
    Key? key,
    this.hash,
    this.borderRadius,
    this.shadow,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String url;
  final String? hash;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadow;
  final BoxShape shape;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: shadow,
            borderRadius: borderRadius,
            shape: shape,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
        placeholder: (context, url) =>
            hash != null ? BlurHash(hash: hash!) : const SizedBox.shrink(),
        errorWidget: (context, url, error) {
          log(error.toString());
          return hash != null ? BlurHash(hash: hash!) : const SizedBox.shrink();
        },
      );
}
