import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_admin/tabs/admin_tabs/dashboard/purchase_bar_chart.dart';
import 'package:lms_admin/tabs/admin_tabs/dashboard/user_bar_chart.dart';
import 'package:lms_admin/mixins/course_mixin.dart';
import 'package:lms_admin/utils/reponsive.dart';
import 'dashboard_purchases.dart';
import 'dashboard_reviews.dart';
import 'dashboard_tile.dart';
import 'dashboard_providers.dart';
import 'dashboard_top_courses.dart';
import 'dashboard_users.dart';

class Dashboard extends ConsumerWidget with CourseMixin {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1c6ea4),
                  Color(0xFF1a2851),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1c6ea4).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LineIcons.pieChart,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Monitor your platform\'s performance and analytics',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Stats Grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: Responsive.getCrossAxisCount(context),
              childAspectRatio: 2.2,
            ),
            children: [
              DashboardTile(
                info: 'Total Users', 
                count: ref.watch(usersCountProvider).value ?? 0, 
                icon: LineIcons.userFriends, 
                bgColor: const Color(0xFFFF6B35)
              ),
              DashboardTile(
                info: 'Total Enrolled', 
                count: ref.watch(enrolledCountProvider).value ?? 0, 
                icon: LineIcons.userTie, 
                bgColor: const Color(0xFF1c6ea4)
              ),
              DashboardTile(
                info: 'Total Subscribed', 
                count: ref.watch(subscriberCountProvider).value ?? 0, 
                icon: LineIcons.userClock, 
                bgColor: const Color(0xFF8B5CF6)
              ),
              DashboardTile(
                info: 'Total Purchases', 
                count: ref.watch(purchasesCountProvider).value ?? 0, 
                icon: LineIcons.receipt, 
                bgColor: const Color(0xFF06B6D4)
              ),
              DashboardTile(
                info: 'Total Authors', 
                count: ref.watch(authorsCountProvider).value ?? 0, 
                icon: LineIcons.userTag, 
                bgColor: const Color(0xFFEC4899)
              ),
              DashboardTile(
                info: 'Total Courses', 
                count: ref.watch(coursesCountProvider).value ?? 0, 
                icon: LineIcons.book, 
                bgColor: const Color(0xFF10B981)
              ),
              DashboardTile(
                info: 'Total Notifications',
                count: ref.watch(notificationsCountProvider).value ?? 0,
                icon: LineIcons.bell,
                bgColor: const Color(0xFF7C3AED)
              ),
              DashboardTile(
                info: 'Total Reviews', 
                count: ref.watch(reviewsCountProvider).value ?? 0, 
                icon: LineIcons.starAlt, 
                bgColor: const Color(0xFF059669)
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildOtherTabs(context),
        ],
      ),
    );
  }

  Widget _buildOtherTabs(BuildContext context) {
    if (Responsive.isDesktopLarge(context)) {
      return const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              child: Column(
                children: [UserBarChart(), SizedBox(height: 20), DashboardReviews()],
              )),
          SizedBox(width: 20),
          Flexible(
              flex: 1,
              child: Column(
                children: [PurchaseBarChart(), SizedBox(height: 20), DashboardUsers()],
              )),
          SizedBox(width: 20),
          Flexible(
              flex: 1,
              child: Column(
                children: [DashboardPurchases(), SizedBox(height: 20), DashboardTopCourses()],
              )),
        ],
      );
    } else if (Responsive.isDesktop(context)) {
      return const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              child: Column(
                children: [
                  UserBarChart(),
                  SizedBox(height: 20),
                  DashboardReviews(),
                  SizedBox(height: 20),
                  DashboardPurchases(),
                ],
              )),
          SizedBox(width: 20),
          Flexible(
              flex: 1,
              child: Column(
                children: [
                  PurchaseBarChart(),
                  SizedBox(height: 20),
                  DashboardUsers(),
                  SizedBox(height: 20),
                  DashboardTopCourses(),
                ],
              )),
        ],
      );
    } else {
      return const Column(
        children: [
          UserBarChart(),
          SizedBox(height: 20),
          PurchaseBarChart(),
          SizedBox(height: 20),
          DashboardReviews(),
          SizedBox(height: 20),
          DashboardPurchases(),
          SizedBox(height: 20),
          DashboardUsers(),
          SizedBox(height: 20),
          DashboardTopCourses(),
        ],
      );
    }
  }
}
