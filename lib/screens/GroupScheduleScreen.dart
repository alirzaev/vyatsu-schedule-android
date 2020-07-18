import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../components/DayScheduleView.dart';
import '../models/FavouriteGroupsModel.dart';
import '../utils/dto.dart' show Group, Schedule;

class _FavouriteButton extends StatelessWidget {
  final Group _group;

  _FavouriteButton(this._group);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteGroupsModel>(
      builder: (context, favouriteGroupsModel, child) {
        final isFavourite = favouriteGroupsModel.contains(_group);
        final icon = Icon(isFavourite ? Icons.favorite : Icons.favorite_border);

        return IconButton(
            icon: icon,
            onPressed: () {
              if (isFavourite) {
                favouriteGroupsModel.remove(_group);
              } else {
                favouriteGroupsModel.add(_group);
              }
            });
      },
    );
  }
}

class GroupScheduleScreen extends StatefulWidget {
  final Group group;

  GroupScheduleScreen({Key key, this.group}) : super(key: key);

  @override
  _GroupScheduleScreenState createState() => _GroupScheduleScreenState();
}

class _GroupScheduleScreenState extends State<GroupScheduleScreen> {
  final String baseUrl = 'https://vyatsu-schedule-api.herokuapp.com';

  Future<String> _fetchSeason() async {
    final response = await http.get('$baseUrl/api/v2/season/current');

    if (response.statusCode == 200) {
      return json.decode(response.body)['season'] as String;
    } else {
      return 'autumn';
    }
  }

  Future<Schedule> _futureSchedule;

  Future<Schedule> _fetchSchedule() async {
    final groupId = widget.group.id;
    final season = await _fetchSeason();
    final response =
        await http.get('$baseUrl/api/v2/schedule/$groupId/$season');

    if (response.statusCode == 200) {
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('ERROR');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureSchedule = _fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.replay),
              onPressed: () {
                setState(() {
                  _futureSchedule = _fetchSchedule();
                });
              }),
          _FavouriteButton(widget.group)
        ],
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<Schedule> snapshot) {
            if (snapshot.hasData) {
              final days =
                  snapshot.data.schedule.expand((week) => week).toList();

              const DAYS = [
                'Понедельник',
                'Вторник',
                'Среда',
                'Четверг',
                'Пятница',
                'Суббота'
              ];
              return ListView.separated(
                  padding: EdgeInsets.all(8),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final dayNameIndex = index % 6;
                    return DayScheduleView(days[index], DAYS[dayNameIndex]);
                  },
                  separatorBuilder: (contex, i) => Divider(thickness: 2.0));
            } else if (snapshot.hasError) {
              return Text('Ошибка при загрузке расписания');
            } else {
              return CircularProgressIndicator();
            }
          },
          future: _futureSchedule,
        ),
      ),
    );
  }
}
