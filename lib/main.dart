

import 'package:aritrairis2020/bloc/todobloc_bloc.dart';
import 'package:aritrairis2020/calendar.dart';
import 'package:aritrairis2020/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:core';
import 'appbar.dart';
import 'todo.dart';
import 'body.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'dialog.dart';

import 'notifications/notifications.dart';

NotificationManager manager=NotificationManager();
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path_provider
      .getApplicationDocumentsDirectory(); //Adding a path provider
  Hive.init(directory.path); //Initializing hive
  Hive.registerAdapter(TodoAdapter()); // Registering the Tod type Adapter

  manager.initNotifications();
  manager.requestIOSPermissions();

  print("Opening directory");
  runApp(MyApp());

}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,   //Removing the debug banner
        home: FutureBuilder(
          future: Hive.openBox('todo'),
          //Opening the box todo where the data will be stored
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("inside builder");
            if (snapshot.connectionState == ConnectionState.done) if (snapshot
                .hasError)
              return Text(
                  snapshot.error.toString()); //Printing the error, if any
            else
             {  manager.getCountOfTodo();
               return SafeArea(child: Secretary());} //Else starting the screen
            else
              return Scaffold();
          },
        ));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose(); //Closing the Hive
  }
}

class Secretary extends StatefulWidget {


  @override
  _SecretaryState createState() => _SecretaryState();

}

class _SecretaryState extends State<Secretary> {


  final TodoblocBloc todoBloc= TodoblocBloc(UseHiveForTodo());

  final TextEditingController _controller =
      TextEditingController(); //Declaring the controller for the adding text field
  CalendarController calendar = CalendarController(); //Calendar Controller for the table calendar

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            //Adding a background image to the app
              image: AssetImage(
                'assets/assistant.jpg',
              ),
              //the color filter is used to modify the visibility
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.modulate),

              //to make the image fit the whole screen
              fit: BoxFit.fill
              )),
      child: BlocProvider(
          create: (context) =>todoBloc,
          child: BlocBuilder<TodoblocBloc, TodoblocState>(
            bloc:todoBloc,
              builder: (context, state) {
                print("${calendar.selectedDay} is the day selected");

            return Scaffold(
              //Adding transparency so that the background image is visible
              backgroundColor: Colors.transparent,
              //Using a custom widget for the appbar and passing the height of the appbar as parameter
              appBar: MyAppBar(
                height: 100.0,
                  ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  tabCalendar(calendar: calendar,todoBloc: todoBloc), //Calendar widget, see calendar.dart
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                      child: buildList(selectedDate: calendar.selectedDay,state: state,todoBloc: todoBloc)), //see body.dart
                ],
              ), //user defined widget
              //Button to add a TODO
              floatingActionButton: FloatingActionButton(

                backgroundColor: Colors.white70.withOpacity(0.6),
                onPressed: () {
                  //Displays a dialogue box
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogBox(
                            Title: "Add TODO",
                            controller: _controller,
                            todoBloc: todoBloc,
                            Manipulation: () {
                              final elements=Hive.box('todo');
                              //Adding the event to add todo
                                 todoBloc.add(AddTodoEvent(entry:Todo(
                                  completed: false,
                                  task: _controller.text,
                                  date: calendar.selectedDay),
                                 ));
                              print("Adding the entry");

                              Navigator.pop(context);
                            });
                      });
                },
                child: Icon(
                  Icons.add,
                  color: Colors.teal[400],
                ),
              ),
            );
          })),
    );
  }

  @override
  void dispose() {
    calendar.dispose();
  todoBloc.close();
    super.dispose();
  }
}

