import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sqflitedemo/db/sqfliteDtatabase.dart';
import 'package:sqflitedemo/model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SqfliteHelper.instance.getTodoList(),
        builder:
            ((BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: snapshot.data!.map((e) {
                  return Center(
                    child: ListTile(
                      title: Text(e.name),
                      subtitle: Text('${e.id}'),
                    ),
                  );
                }).toList(),
              );
            }
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('No ToDo List Found'),
            );
          }
          return const CircularProgressIndicator();
        }),
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
    );
  }
}
