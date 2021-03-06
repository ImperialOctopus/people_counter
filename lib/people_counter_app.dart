import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/room/room_bloc.dart';
import 'config.dart' as config;
import 'screen/preset_room_screen.dart';
import 'screen/room_navigator.dart';
import 'screen/room_select_screen.dart';
import 'service/database/database_service.dart';
import 'service/database/firebase_database_service.dart';
import 'theme/theme.dart';

/// Full app widget.
class PeopleCounterApp extends StatefulWidget {
  @override
  _PeopleCounterAppState createState() => _PeopleCounterAppState();
}

class _PeopleCounterAppState extends State<PeopleCounterApp> {
  Future<FirebaseApp> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appTitle,
      theme: themeData,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  // ignore: lines_longer_than_80_chars
                  'We had a problem connecting to the internet.\nPlease try restarting this app.'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return AppView();
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

/// Stateful app view.
class AppView extends StatefulWidget {
  /// Stateful app view.
  const AppView();

  @override
  State<StatefulWidget> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  DatabaseService _databaseService;

  RoomBloc _roomBloc;

  @override
  void initState() {
    super.initState();

    _databaseService = FirebaseDatabaseService();

    _roomBloc = RoomBloc(_databaseService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DatabaseService>.value(value: _databaseService),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<RoomBloc>.value(value: _roomBloc),
          ],
          child: Navigator(
            pages: [
              MaterialPage(
                child: RoomNavigator(
                  roomSelect: config.presetRoom
                      ? PresetRoomScreen(
                          title: config.appTitle, roomName: config.presetName)
                      : RoomSelectScreen(title: config.appTitle),
                ),
              ),
            ],
            onPopPage: (route, result) => route.didPop(result),
          )),
    );
  }
}
