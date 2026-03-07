import 'package:flutter/material.dart';

class AppScreenWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Color backgroundColor;
  final bool safeBottom;

  const AppScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.appBar,
    this.backgroundColor = Colors.white,
    this.safeBottom = true,
  }) : assert(
         title == null || appBar == null,
         'Provide either title or appBar, not both',
       );

  @override
  Widget build(BuildContext context) {
    final body = safeBottom
        ? SafeArea(top: false, left: false, right: false, child: child)
        : child;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          appBar ??
          (title != null
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              : null),
      body: body,
    );
  }
}
