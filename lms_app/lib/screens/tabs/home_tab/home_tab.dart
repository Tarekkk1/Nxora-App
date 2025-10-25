import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/components/app_logo.dart';
import 'package:lms_app/screens/tabs/home_tab/top_authors.dart';
import 'package:lms_app/screens/notifications/notifications.dart';
import 'package:lms_app/screens/search/search_view.dart';
import 'package:lms_app/screens/wishlist.dart';
import 'package:lms_app/utils/next_screen.dart';
import '../../../providers/app_settings_provider.dart';
import 'category1_courses.dart';
import 'category2_courses.dart';
import 'category3_courses.dart';
import 'featured_courses.dart';
import 'free_courses.dart';
import 'home_categories.dart';
import 'home_latest_courses.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
            if (showBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    return RefreshIndicator.adaptive(
      displacement: 60,
      onRefresh: () async {
        ref.invalidate(featuredCoursesProvider);
        ref.invalidate(homeCategoriesProvider);
        ref.invalidate(freeCoursesProvider);
        ref.invalidate(category1CoursessProvider);
        ref.invalidate(category2CoursessProvider);
        ref.invalidate(category3CoursessProvider);
        ref.invalidate(topAuthorsProvider);
        ref.invalidate(homeLatestCoursesProvider);
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const AppLogo(
                                height: 32,
                                width: 80,
                              ),
                            ),
                            const Spacer(),
                            _buildActionButton(
                              icon: FeatherIcons.search,
                              onTap: () => NextScreen.iOS(context, const SearchScreen()),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              icon: FeatherIcons.heart,
                              onTap: () => NextScreen.iOS(context, const Wishlist()),
                              showBadge: false,
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              icon: LineIcons.bell,
                              onTap: () => NextScreen.iOS(context, const Notifications()),
                              showBadge: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'Discover new courses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Visibility(visible: settings?.featured ?? true, child: const FeaturedCourses()),
                Visibility(visible: settings?.categories ?? true, child: const HomeCategories()),
                Visibility(visible: settings?.freeCourses ?? true, child: const FreeCourses()),
                if (settings != null && settings.homeCategory1 != null) Category1Courses(category: settings.homeCategory1!),
                if (settings != null && settings.homeCategory2 != null) Category2Courses(category: settings.homeCategory2!),
                if (settings != null && settings.homeCategory3 != null) Category3Courses(category: settings.homeCategory3!),
                // Visibility(visible: settings?.topAuthors ?? true, child: const TopAuthors()),
                Visibility(visible: settings?.latestCourses ?? true, child: const HomeLatestCourses()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
