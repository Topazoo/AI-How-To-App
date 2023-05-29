import 'package:flutter/material.dart';

import '../../models/guide.dart';

import 'components/requirement_detail.dart';
import 'components/section_title.dart';
import 'components/step_detail.dart';

class HowToGuideDetailPage extends StatefulWidget {
  final Guide guide;

  const HowToGuideDetailPage({Key? key, required this.guide}) : super(key: key);

  @override
  HowToGuideDetailPageState createState() => HowToGuideDetailPageState();
}

class HowToGuideDetailPageState extends State<HowToGuideDetailPage> {
  List<bool> _stepChecklist = [];
  List<bool> _requirementChecklist = [];

  @override
  void initState() {
    super.initState();
    _stepChecklist = List<bool>.filled(widget.guide.steps.length, false);
    _requirementChecklist = List<bool>.filled(widget.guide.requirements.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guide.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SectionTitle('Description:'),
            Text(widget.guide.description),
            const Divider(),
            Text('Estimated Time: ${widget.guide.estimatedTime}'),
            const Divider(),
            const SectionTitle('Notes:'),
            Text(widget.guide.notes),
            const Divider(),
            const SectionTitle('Requirements:'),
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
            const SectionTitle('Steps:'),
            for (int i = 0; i < widget.guide.steps.length; i++)
              StepDetail(
                step: widget.guide.steps[i],
                isChecked: _stepChecklist[i],
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
