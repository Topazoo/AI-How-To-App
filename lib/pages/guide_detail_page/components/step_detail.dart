import 'package:flutter/material.dart';

import '../../../models/guide_step.dart';
import '../../../utilities/timer.dart';
import '../../../styles/theme.dart';

class StepDetail extends StatelessWidget {
  final bool isChecked;
  final GuideStep step;
  final ValueChanged<bool?> onChanged;
  final List<TimerWidget> timers;

  const StepDetail({Key? key, required this.step, required this.isChecked, required this.onChanged, required this.timers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: AppTheme.primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${step.stepNumber}:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
                    ),
                    Text(
                      step.instruction,
                      style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ...timers
        ],
      ),
    );
  }
}
