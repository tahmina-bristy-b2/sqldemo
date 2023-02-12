import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflitedemo/screen/location.dart';
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
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationScreen()));
                },
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LocationScreen()));
                  },
                  icon: const Icon(Icons.personal_injury),
                ),
                title: const Text('Location'),
              ),
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
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.50,
                            children: [
                              SlidableAction(
                                label: 'Delete',
                                backgroundColor: Color(0xffffafcc),
                                icon: Icons.delete_forever,
                                onPressed: (context) {
                                  setState(() {
                                    SqfliteHelper.instance
                                        .removeTodoList(e.id!);
                                  });
                                },
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.50,
                            children: [
                              SlidableAction(
                                label: 'Edit',
                                backgroundColor: Color(0xffccd5ae),
                                icon: Icons.edit,
                                onPressed: (context) {
                                  setState(() {
                                    isShow = true;
                                    selectedId = e.id;
                                  });
                                },
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                                // const Text('1'),
                                // const SizedBox(width: 8),
                                Row(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    "${e.id}",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                )),
                                Expanded(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Container(
                                      // ignore: prefer_const_constructors
                                      decoration: BoxDecoration(
                                          color: const Color(0xffcca5de),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                      child: ListTile(
                                        title: Text(
                                          e.name,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          '${e.id}',
                                          // ignore: prefer_const_constructors
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
          backgroundColor: Color(0xff84a9a6),
          child: const Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? SqfliteHelper.instance.updateTodoList(
                    TodoModel(id: selectedId, name: controller.text))
                : controller.text != ''
                    ? await SqfliteHelper.instance
                        .createTodoList(TodoModel(name: controller.text))
                    : print('');
            setState(() {
              controller.clear();
              isShow = false;
            });
          }),
    );
  }
}
