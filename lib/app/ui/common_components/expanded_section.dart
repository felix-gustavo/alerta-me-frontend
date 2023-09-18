import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {
  final Widget? child;
  final bool expand;
  final Axis axis;
  final void Function()? onEnd;

  const ExpandedSection({
    Key? key,
    this.child,
    this.expand = false,
    this.axis = Axis.vertical,
    this.onEnd,
  }) : super(key: key);

  @override
  State<ExpandedSection> createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool _previousExpand = false;

  @override
  void initState() {
    super.initState();
    _previousExpand = widget.expand;
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward().whenComplete(() => widget.onEnd?.call());
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand != _previousExpand) {
      _previousExpand = widget.expand;
      _runExpandCheck();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: widget.axis,
      axisAlignment: 1,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
