import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflitedemo/services/sqfliteDtatabase.dart';
import 'package:sqflitedemo/model/model.dart';
import 'package:sqflitedemo/screen/background_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isShow = false;
  int? selectedId;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isShow = true;
                });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BackGroundServicesScreen()));
                },
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BackGroundServicesScreen()));
                  },
                  icon: const Icon(Icons.personal_injury),
                ),
                title: const Text('Background Service'),
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: SqfliteHelper.instance.getTodoList(),
        builder:
            ((BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading........"));
          }

          return isShow == false
              ? snapshot.data!.isEmpty
                  ? const Center(child: Text('No todoList Found'))
                  : ListView(
                      children: snapshot.data!.map((e) {
                        return Center(
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                SqfliteHelper.instance.removeTodoList(e.id!);
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                isShow = true;
                                selectedId = e.id;
                              });
                            },
                            title: Text(e.name),
                            subtitle: Text('${e.id}'),
                          ),
                        );
                      }).toList(),
                    )
              : TextField(
                  controller: controller,
                );

          return const CircularProgressIndicator();
        }),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? SqfliteHelper.instance.updateTodoList(
                    TodoModel(id: selectedId, name: controller.text))
                : await SqfliteHelper.instance
                    .createTodoList(TodoModel(name: controller.text));
            setState(() {
              controller.clear();
              isShow = false;
            });
          }),
    );
  }
}
