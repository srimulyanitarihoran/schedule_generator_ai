import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';
import 'package:schedule_generator_ai/services/gemini_service.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isLoading = false;
  final List<Task> tasks = []; // wadah untuk menmapung task dari user
  String scheduleResult = ''; // wadah untuk menampung task hasil generate schedule dari gemini
  final GeminiService geminiservice = GeminiService();

  Future<void> _generateSchedule() async {
    setState(() => isLoading = true);
    try {
      String schedule = await geminiservice.generateSchedule(tasks);
      setState(() => scheduleResult = schedule);
    } catch (e) {
      setState(() => scheduleResult = e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Generator'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHeader(),
          // TODO: peletakan component add tasks card disini
          // TODO: letakkan component task list disini
          _buildGenerateButton()
        ],
      ),
    );
  }

  Widget _buildHeader () {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "plan ur day faster",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  )
                ),
                Text(
                  "add tasks and generate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  ),
                )
              ],
            ),
          ),
          Chip(label: Text('${tasks.length} tasks'))
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return FilledButton.icon(
      onPressed: (isLoading || tasks.isEmpty) ? null : _generateSchedule,
      icon: isLoading
          ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
          : Icon(Icons.auto_awesome_rounded),
      label: Text(isLoading ? 'Generating...' : 'generate schedule'),
    );
  }
}