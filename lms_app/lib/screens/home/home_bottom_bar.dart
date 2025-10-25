import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/home/home_view.dart';
import 'package:lms_app/theme/theme_provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Bottom Tabs
const Map<int, List> homeTabs = {
  1: ['home', FeatherIcons.home],
  2: ['search', FeatherIcons.search],
  3: ['my-courses', FeatherIcons.book],
  4: ['profile', FeatherIcons.user],
};

final navBarIndexProvider = StateProvider<int>((ref) => 0);

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navBarIndexProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SalomonBottomBar(
          curve: Curves.easeInOut,
          currentIndex: currentIndex,
          margin: const EdgeInsets.all(16),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          backgroundColor: Colors.transparent,
          onTap: (int index) {
            ref.read(navBarIndexProvider.notifier).state = index;
            if (_shouldAnimate(currentIndex, index)) {
              ref
                  .read(homeTabControllerProvider.notifier)
                  .state
                  .animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            } else {
              ref.read(homeTabControllerProvider.notifier).state.jumpToPage(index);
            }
          },
          items: homeTabs.entries.map((e) {
            return SalomonBottomBarItem(
              icon: Icon(e.value[1], size: 22),
              title: Text(
                e.value[0],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ).tr(),
            );
          }).toList()),
    );
  }

  bool _shouldAnimate(int currentIndex, int newIndex) {
    int dif = currentIndex - newIndex;
    if (dif > 1 || dif < -1) {
      return false;
    } else {
      return true;
    }
  }
}
