import 'package:flutter/material.dart';
import '../../../styles/theme.dart';
import '../../../utilities/timer.dart';
import '../../../utilities/time_parser/time_parser.dart';
import '../../models/guide.dart';
import 'components/requirement_detail.dart';
import 'components/section_title.dart';
import 'components/step_detail.dart';

class GuideDetailPage extends StatefulWidget {
  final Guide guide;

  const GuideDetailPage({Key? key, required this.guide}) : super(key: key);

  @override
  GuideDetailPageState createState() => GuideDetailPageState();
}

class GuideDetailPageState extends State<GuideDetailPage> {
  List<bool> _stepChecklist = [];
  List<bool> _requirementChecklist = [];
  final Map<int, List<TimerWidget>> _timerWidgets = {};  // Hold the TimerWidgets here

  @override
  void initState() {
    super.initState();
    _stepChecklist = List<bool>.filled(widget.guide.steps.length, false);
    _requirementChecklist = List<bool>.filled(widget.guide.requirements.length, false);

    for (int i = 0; i < widget.guide.steps.length; i++) {
      List<int> durations = TimeParser.extractDurations(widget.guide.steps[i].instruction);
      if (durations.isNotEmpty) {
        _timerWidgets[i] = durations.map((duration) => TimerWidget(duration: duration)).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.guide.title,
          style: const TextStyle(color: Colors.white, fontFamily: AppTheme.primaryFont),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SectionTitle('Description:', icon: Icons.description_outlined),
            Text(
              widget.guide.description,
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
            const Divider(),
            const SectionTitle('Estimated Time:', icon: Icons.timelapse),
            Text(
              widget.guide.estimatedTime,
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
            const Divider(),
            const SectionTitle('Notes:', icon: Icons.notes),
            Text(
              widget.guide.notes,
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
            const Divider(),
            const SectionTitle('Requirements:', icon: Icons.inventory_2_outlined),
            for (int i = 0; i < widget.guide.requirements.length; i++)
              RequirementDetail(
                requirement: widget.guide.requirements[i], 
                isChecked: _requirementChecklist[i], 
                onChanged: (bool? value) {
                  setState(() {
                    _requirementChecklist[i] = value!;
                  });
                },
              ),
            const Divider(),
            const SectionTitle('Steps:', icon: Icons.check),
            for (int i = 0; i < widget.guide.steps.length; i++)
              StepDetail(
                step: widget.guide.steps[i],
                isChecked: _stepChecklist[i],
                timers: _timerWidgets[i] ?? [],  // Pass the list of TimerWidgets to StepDetail
                onChanged: (bool? value) {
                  setState(() {
                    _stepChecklist[i] = value!;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
