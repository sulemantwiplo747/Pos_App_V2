import 'package:flutter/material.dart';

class AnimatedFamilyMemberTile extends StatefulWidget {
  final Widget child;
  final int index;


   AnimatedFamilyMemberTile({
    super.key,
    required this.child,
    required this.index,

  });

  @override
  State<AnimatedFamilyMemberTile> createState() =>
      _AnimatedFamilyMemberTileState();
}

class _AnimatedFamilyMemberTileState extends State<AnimatedFamilyMemberTile>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slideOffset;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _slideOffset = Tween<Offset>(
      begin: const Offset(0, 0.15), // small slide
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slideOffset, child: widget.child),
    );
  }
}
