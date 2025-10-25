import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import '../../../components/custom_buttons.dart';
import '../../../components/dialogs.dart';
import '../../../configs/constants.dart';
import '../../../forms/student_form.dart';
import '../../../mixins/appbar_mixin.dart';
import '../../../utils/reponsive.dart';
import 'sort_users_button.dart';
import '../../../mixins/textfields.dart';
import '../../../mixins/users_mixin.dart';
import 'search_users_textfield.dart';

final usersQueryProvider = StateProvider<Query>((ref) {
  final query = FirebaseFirestore.instance.collection('users').orderBy('created_at');
  return query;
});

final sortByUsersTextProvider = StateProvider<String>((ref) => sortByUsers.entries.first.value);
final searchUsersFieldProvider = Provider<TextEditingController>((ref) => TextEditingController());

class Users extends ConsumerWidget with UsersMixins, TextFields {
  const Users({Key? key}) : super(key: key);

  void _handleCreateStudent(BuildContext context) {
    CustomDialogs.openResponsiveDialog(
      context,
      widget: const StudentForm(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          AppBarMixin.buildTitleBar(
            context, 
            title: 'Users Management', 
            subtitle: 'Manage students, authors and administrators',
            icon: LineIcons.userFriends,
            buttons: [
              CustomButtons.customOutlineButton(
                context,
                icon: Icons.person_add_rounded,
                text: 'Create Student',
                onPressed: () => _handleCreateStudent(context),
              ),
              if (!Responsive.isMobile(context)) ...[
                SerachUsersTextField(ref: ref),
              ],
              SortUsersButton(ref: ref),
            ]
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: buildUsers(context, ref: ref, isMobile: Responsive.isMobile(context)),
            ),
          ),
        ],
      ),
    );
  }
}
