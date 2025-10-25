import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_admin/mixins/appbar_mixin.dart';
import 'package:lms_admin/mixins/categories_mixin.dart';
import 'package:lms_admin/components/custom_buttons.dart';
import 'package:lms_admin/components/dialogs.dart';
import 'package:lms_admin/tabs/admin_tabs/categories/set_order_category.dart';
import '../../../forms/category_form.dart';

class Categories extends ConsumerWidget with CategoriesMixin {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          AppBarMixin.buildTitleBar(
            context, 
            title: 'Categories Management', 
            subtitle: 'Organize your courses with categories',
            icon: LineIcons.layerGroup,
            buttons: [
              CustomButtons.customOutlineButton(
                context,
                icon: LineIcons.sortAmountDown,
                text: 'Set Order',
                bgColor: const Color(0xFF1c6ea4),
                foregroundColor: Colors.white,
                onPressed: () {
                  CustomDialogs.openResponsiveDialog(context, widget: const SetCategoryOrder());
                },
              ),
              CustomButtons.customOutlineButton(
                context,
                icon: Icons.add_rounded,
                text: 'Add Category',
                bgColor: const Color(0xFF1c6ea4),
                foregroundColor: Colors.white,
                onPressed: () {
                  CustomDialogs.openResponsiveDialog(context, widget: const CategoryForm(category: null));
                },
              ),
            ]
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: buildCategories(context, ref: ref),
            ),
          ),
        ],
      ),
    );
  }
}
