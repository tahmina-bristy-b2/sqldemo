import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackGroundServicesScreen extends StatefulWidget {
  const BackGroundServicesScreen({super.key});

  @override
  State<BackGroundServicesScreen> createState() =>
      _BackGroundServicesScreenState();
}

class _BackGroundServicesScreenState extends State<BackGroundServicesScreen> {
  String text = "Stop Service";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            StreamBuilder<Map<String, dynamic>?>(
                stream: FlutterBackgroundService().on('update'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data;
                  String? deviceName = data!['device'];
                  DateTime? date = DateTime.tryParse(data['current_date']);
                  return Column(
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Center(
                        child: Text(
                          deviceName ?? 'Unknown',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(date.toString()),
                      ElevatedButton(
                          onPressed: () {
                            FlutterBackgroundService()
                                .invoke("setAsForeground");
                          },
                          child: const Text('Forground Mode')),
                      ElevatedButton(
                          onPressed: () {
                            FlutterBackgroundService()
                                .invoke("setAsBackground");
                          },
                          child: const Text('Background Mode')),
                      // ElevatedButton(
                      //   child: Text(text),
                      //   onPressed: () async {
                      //     final service = FlutterBackgroundService();
                      //     var isRunning = await service.isRunning();
                      //     if (isRunning) {
                      //       service.invoke("stopService");
                      //     } else {
                      //       service.startService();
                      //     }

                      //     if (!isRunning) {
                      //       text = 'Stop Service';
                      //     } else {
                      //       text = 'Start Service';
                      //     }
                      //     setState(() {});
                      //   },
                      // ),
                      ElevatedButton(
                        onPressed: () async {
                          final service = FlutterBackgroundService();
                          var isRunning = await service.isRunning();
                          print(
                              "#######################$isRunning#######################");
                          if (isRunning) {
                            service.invoke("stopService");
                          } else {
                            service.startService();
                          }

                          if (!isRunning) {
                            text = 'stop Service';
                          } else {
                            text = 'start service';
                          }
                          setState(() {});
                        },
                        child: Text(text),
                      )
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
