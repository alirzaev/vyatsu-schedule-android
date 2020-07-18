import 'package:flutter/material.dart';

class DayScheduleView extends StatelessWidget {
  final List<String> _schedule;

  final String _day;

  DayScheduleView(this._schedule, this._day);

  @override
  Widget build(BuildContext context) {
    final tiles =
        _schedule.map((lesson) => ListTile(title: Text(lesson))).toList();

    final divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    final dayTitle = Text(
      _day,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );

    return Column(
      children: <Widget>[
            Center(
              child: dayTitle,
              heightFactor: 1.5,
            ),
            Divider()
          ] +
          divided,
    );
  }
}
