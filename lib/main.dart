import 'package:vyatsu_schedule/screens/FacultyChooserScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/FavouriteGroupsView.dart';
import 'models/FavouriteGroupsModel.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => FavouriteGroupsModel(), child: VyatSuScheduleApp()));
}

class VyatSuScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Расписание',
        theme: ThemeData(
          primaryColor: Color(0xFF3F51B5),
          primaryColorLight: Color(0xFF757DE8),
          primaryColorDark: Color(0xFF002984),
          primaryTextTheme:
              Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(title: 'Расписание'));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _pushFacultyChooser(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return FacultyChooserScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расписание')),
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(child: FavouriteGroupsView()),
          Center(
            child: FlatButton(
                child: Text('Выбрать другую группу'),
                onPressed: () {
                  _pushFacultyChooser(context);
                }),
          )
        ],
      )),
    );
  }
}
