import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_admin/configs/constants.dart';
import 'package:lms_admin/mixins/appbar_mixin.dart';
import 'package:lms_admin/mixins/course_mixin.dart';
import 'package:lms_admin/components/custom_buttons.dart';
import 'package:lms_admin/tabs/admin_tabs/courses/sort_courses_button.dart';
import '../../../components/dialogs.dart';
import '../../../forms/course_form.dart';

final courseQueryprovider = StateProvider<Query>((ref) {
  final query = FirebaseFirestore.instance.collection('courses').orderBy('created_at', descending: true);
  return query;
});

final sortByCourseTextProvider = StateProvider<String>((ref) => sortByCourse.entries.first.value);

class Courses extends ConsumerWidget with CourseMixin {
  const Courses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          AppBarMixin.buildTitleBar(
            context, 
            title: 'Courses Management', 
            subtitle: 'Create, edit and manage all your courses',
            icon: LineIcons.book,
            buttons: [
              CustomButtons.customOutlineButton(
                context,
                icon: Icons.add_rounded,
                text: 'Create Course',
                bgColor: const Color(0xFF1c6ea4),
                foregroundColor: Colors.white,
                onPressed: () {
                  CustomDialogs.openFullScreenDialog(context, widget: const CourseForm(course: null));
                },
              ),
              SortCoursesButton(ref: ref),
            ]
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: buildCourses(context, ref: ref, queryProvider: courseQueryprovider),
            ),
          ),
        ],
      ),
    );
  }
}
