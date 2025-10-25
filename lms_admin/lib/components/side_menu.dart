import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_admin/components/app_logo.dart';
import 'package:lms_admin/configs/assets_config.dart';
import 'package:lms_admin/configs/constants.dart';
import 'package:lms_admin/pages/home.dart';
import 'package:lms_admin/providers/auth_state_provider.dart';

final menuIndexProvider = StateProvider<int>((ref) => 0);

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
    required this.scaffoldKey,
    required this.role,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserRoles role;

  @override
  Widget build(BuildContext context) {
    final bool isAuthor = role == UserRoles.author ? true : false;
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1c6ea4),
              Color(0xFF1a2851),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20, top: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const AppLogo(
                        imageString: AssetsConfig.logoDark,
                        height: 40,
                        width: 140,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isAuthor ? 'Author Panel' : 'Admin Panel',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: isAuthor ? menuListAuthor.length : menuList.length,
                itemBuilder: (BuildContext context, int index) {
                  String title = isAuthor ? menuListAuthor[index]![0] : menuList[index]![0];
                  IconData icon = isAuthor ? menuListAuthor[index]![1] : menuList[index]![1];
                  return _DrawerListTile(
                    title: title,
                    icon: icon,
                    index: index,
                    scaffoldKey: scaffoldKey,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerListTile extends ConsumerWidget {
  const _DrawerListTile({Key? key, required this.title, required this.icon, required this.index, required this.scaffoldKey}) : super(key: key);

  final String title;
  final IconData icon;
  final int index;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIndex = ref.watch(menuIndexProvider);
    bool selected = menuIndex == index;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          border: selected ? Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ) : null,
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () => _onTap(context, ref, menuIndex),
          horizontalTitleGap: 12.0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected 
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(context, WidgetRef ref, int newIndex) {
    ref.read(menuIndexProvider.notifier).update((state) => index);
    bool shouldAnimate = _shouldAnimate(index, newIndex);
    if (shouldAnimate) {
      ref.read(pageControllerProvider.notifier).state.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.ease);
    } else {
      ref.read(pageControllerProvider.notifier).state.jumpToPage(index);
    }
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
    }
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
