import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sqflitedemo/main.dart';
import 'package:sqflitedemo/screen/location.dart';
import 'package:sqflitedemo/services/sqfliteDtatabase.dart';
import 'package:sqflitedemo/model/model.dart';
import 'package:sqflitedemo/screen/background_service.dart';

class HivedatabaseHomeScreen extends StatefulWidget {
  const HivedatabaseHomeScreen({super.key});

  @override
  State<HivedatabaseHomeScreen> createState() => _HivedatabaseHomeScreenState();
}

class _HivedatabaseHomeScreenState extends State<HivedatabaseHomeScreen> {
  bool isShow = false;
  int? selectedId;
  String? title;
  String? description;
  String address1 = '';
  TextEditingController controller = TextEditingController();
  TextEditingController desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = (selectedId != null ? title : '')!;
    desController.text = (selectedId != null ? description : '')!;

    print('{{{{{{{{{{{{{{{{{{{{{0000$address1}}}}}}}}}}}}}}}}}}}}}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Home Page'),
        backgroundColor: Color(0xff84a9a6),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isShow = true;
                  address = address;
                  print(
                      '{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{$address}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');
                });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
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
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HivedatabaseHomeScreen()));
                },
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HivedatabaseHomeScreen()));
                  },
                  icon: const Icon(Icons.personal_injury),
                ),
                title: const Text('Hive Database Data'),
              )
            ],
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('TodoData').listenable(),
        builder: ((context, box, child) {
          if (!box.isEmpty) {
            return const Center(child: Text("Loading........"));
          }

          return isShow == false
              ? box.isEmpty
                  ? const Center(child: Text('No todoList Found'))
                  : ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final data =
                            Hive.box('TodoData').getAt(index) as TodoModel;

                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.50,
                            children: [
                              SlidableAction(
                                label: 'Delete',
                                backgroundColor: const Color(0xffffafcc),
                                icon: Icons.delete_forever,
                                onPressed: (context) {
                                  // setState(() {
                                  //   SqfliteHelper.instance
                                  //       .removeTodoList(e.id!);
                                  // });
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
                                backgroundColor: const Color(0xffccd5ae),
                                icon: Icons.edit,
                                onPressed: (context) {
                                  setState(() {
                                    isShow = true;
                                    selectedId = data.id;
                                    title = data.name;
                                    description = data.description;
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
                                    "$data",
                                    // ignore: prefer_const_constructors
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
                                          data.name,
                                          // ignore: prefer_const_constructors
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          data.location,
                                          // ignore: prefer_const_constructors
                                          style: const TextStyle(
                                              color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        textCapitalization: TextCapitalization
                            .sentences, // Capital first letter
                        keyboardType: TextInputType.text,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                            hintText: 'ADD TITLE',
                            hintStyle: TextStyle(
                                fontSize: 24,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                            border: InputBorder.none),
                        onChanged: (val) {
                          controller.value = TextEditingValue(
                              text: val.toUpperCase(),
                              selection: controller.selection);

                          // setState(() {});

                          // val.toUpperCase();
                        },

                        // textCapitalization: TextCapitalization.characters,
                        controller: controller,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          // Capital first letter
                          keyboardType: TextInputType.text,
                          maxLines: 100,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                              hintText: 'Description ',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              border: InputBorder.none),

                          // textCapitalization: TextCapitalization.characters,
                          controller: desController,
                        ),
                      ),
                    ),
                  ],
                );

          return const CircularProgressIndicator();
        }),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff84a9a6),
          child: const Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? SqfliteHelper.instance.updateTodoList(TodoModel(
                    id: selectedId,
                    name: controller.text,
                    description: desController.text,
                    location: address))
                : controller.text != ''
                    ? await SqfliteHelper.instance.createTodoList(TodoModel(
                        name: controller.text,
                        description: desController.text,
                        location: address))
                    : print('');
            setState(() {
              controller.clear();
              desController.clear();
              isShow = false;
            });
          }),
    );
  }
}
