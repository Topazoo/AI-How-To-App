import 'package:flutter/material.dart';

import '../../../models/requirement.dart';
import '../../../styles/theme.dart';

class RequirementDetail extends StatelessWidget {
  final bool isChecked;
  final Requirement requirement;
  final ValueChanged<bool?> onChanged;

  const RequirementDetail({Key? key, required this.requirement, required this.isChecked, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
          Expanded(
            child: Text(
              '${requirement.quantity} ${requirement.item}',
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
          ),
        ],
      ),
    );
  }
}
