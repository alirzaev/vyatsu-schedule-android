import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'GroupChooserScreen.dart';

import '../utils/dto.dart' show Faculty;

class FacultyChooserScreen extends StatefulWidget {
  @override
  _FacultyChooserScreenState createState() => _FacultyChooserScreenState();
}

class _FacultyChooserScreenState extends State<FacultyChooserScreen> {
  final String baseUrl = 'https://vyatsu-schedule-api.herokuapp.com';

  Future<List<Faculty>> _futureFaculties;

  Future<List<Faculty>> _fetchFaculties() async {
    final response = await http.get('$baseUrl/api/v2/groups/by_faculty');

    if (response.statusCode == 200) {
      final facultiesJson = json.decode(response.body) as List<dynamic>;

      final faculties = facultiesJson.map((facultyJson) {
        return Faculty.fromJson(facultyJson as Map<String, dynamic>);
      }).toList();

      return faculties;
    } else {
      throw Exception('ERROR');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureFaculties = _fetchFaculties();
  }

  void _pushGroupChooser(BuildContext context, Faculty faculty) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupChooserScreen(faculty.groups)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите факультет'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.replay),
              onPressed: () {
                setState(() {
                  _futureFaculties = _fetchFaculties();
                });
              })
        ],
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<List<Faculty>> snapshot) {
            if (snapshot.hasData) {
              final faculties = snapshot.data;

              return ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        title: Text(faculties[index].name),
                        onTap: () {
                          _pushGroupChooser(context, faculties[index]);
                        },
                      ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: faculties.length);
            } else if (snapshot.hasError) {
              return Text('Ошибка при загрузке факультетов');
            } else {
              return CircularProgressIndicator();
            }
          },
          future: _futureFaculties,
        ),
      ),
    );
  }
}
