import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

import '../../shared/extensions/colors_app_extension.dart';

class ContainerReminder extends StatefulWidget {
  final Widget action;
  final Widget page;
  final String pageName;
  final Widget history;

  const ContainerReminder({
    Key? key,
    required this.action,
    required this.page,
    required this.pageName,
    required this.history,
  }) : super(key: key);

  @override
  State<ContainerReminder> createState() => _ContainerReminderState();
}

class _ContainerReminderState extends State<ContainerReminder>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();

    _tabController.addListener(() {
      if (_tabController.index != _pageController.page?.toInt()) {
        _pageController.animateToPage(_tabController.index,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
      }
    });

    _pageController.addListener(() {
      if (_tabController.index != _pageController.page?.toInt()) {
        _tabController.animateTo(_pageController.page?.toInt() ?? 0,
            duration: const Duration(milliseconds: 100));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shadowColor: context.colors.primaryLight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                physics: const NeverScrollableScrollPhysics(),
                labelColor: context.colors.primary,
                indicatorColor: context.colors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 3,
                enableFeedback: false,
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 12,
                ),
                labelPadding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                tabs: [
                  Text(widget.pageName),
                  const Text('Histórico'),
                ],
              ),
              widget.action,
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ExpandablePageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                widget.page,
                widget.history,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
