import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_admin/configs/app_config.dart';
import 'package:lms_admin/mixins/appbar_mixin.dart';
import 'package:lms_admin/providers/auth_state_provider.dart';
import 'package:lms_admin/tabs/admin_tabs/license_tab.dart';
import 'package:lms_admin/utils/reponsive.dart';
import 'package:lms_admin/components/side_menu.dart';
import 'package:lms_admin/mixins/user_mixin.dart';
import 'package:lms_admin/tabs/author_tabs/author_course_reviews.dart';
import 'package:lms_admin/tabs/author_tabs/author_courses.dart';
import 'package:lms_admin/tabs/author_tabs/author_dashboard.dart';
import '../models/user_model.dart';
import '../providers/categories_provider.dart';
import '../providers/user_data_provider.dart';
import '../tabs/admin_tabs/ads_settings.dart';
import '../tabs/admin_tabs/app_settings/app_settings_view.dart';
import '../tabs/admin_tabs/categories/categories.dart';
import '../tabs/admin_tabs/courses/courses.dart';
import '../tabs/admin_tabs/dashboard/dashboard.dart';
import '../tabs/admin_tabs/featured_courses.dart';
import '../tabs/admin_tabs/notifications.dart';
import '../tabs/admin_tabs/purchases/purchases.dart';
import '../tabs/admin_tabs/reviews/reviews.dart';
import '../tabs/admin_tabs/tags.dart';
import '../tabs/admin_tabs/users/users.dart';

final pageControllerProvider = StateProvider<PageController>((ref) => PageController(initialPage: 0, keepPage: true));

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final List<Widget> _tabList = const [
    Dashboard(),
    Courses(),
    FeaturedCourses(),
    Categories(),
    Tags(),
    Reviews(),
    Users(),
    Notifications(),
    Purchases(),
    AdsSettings(),
    AppSettings(),
    LicenseTab(),
  ];

  final List<Widget> _authorTabList = const [
    AuthorDashboard(),
    AuthorCourses(),
    AuthorCourseReviews(),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ref.read(categoriesProvider.notifier).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    const title = AppConfig.appName;
    final pageController = ref.watch(pageControllerProvider);
    final role = ref.watch(userRoleProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      key: scaffoldKey,
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
        role: role,
      ),
      body: Row(
        children: [
          Visibility(
            visible: Responsive.isDesktop(context) || Responsive.isDesktopLarge(context),
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1c6ea4),
                    Color(0xFF1a2851),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: SideMenu(
                scaffoldKey: scaffoldKey,
                role: role,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _AppTitleBar(
                  title: title,
                  scaffoldKey: scaffoldKey,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                    ),
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: role == UserRoles.author ? _authorTabList : _tabList,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AppTitleBar extends ConsumerWidget with AppBarMixin, UserMixin {
  const _AppTitleBar({
    required this.title,
    required this.scaffoldKey,
  });

  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(userDataProvider);
    return Container(
      height: 70,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 15 : 30),
      child: Row(
        children: [
          buildMenuButton(context, scaffoldKey: scaffoldKey),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1c6ea4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$title Admin",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1a2851),
              ),
            ),
          ),
          const Spacer(),
          buildUserMenuButton(context, user: user, ref: ref)
        ],
      ),
    );
  }
}
