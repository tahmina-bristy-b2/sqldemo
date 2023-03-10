import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sqflitedemo/hive/todo_model_hive.dart';
import 'package:sqflitedemo/screen/background_service.dart';
import 'package:sqflitedemo/screen/hive_database_data_home.dart';
import 'package:sqflitedemo/screen/home_page.dart';
import 'package:sqflitedemo/services/hive_database_Service.dart';
import 'package:sqflitedemo/services/locationServices.dart';

late Box box;
double lat = 0.0;
double long = 0.0;
String address = '';
String globalAddress = '';
String roadName = '';
String countryName = '';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeService();
//   await Hive.initFlutter();
//   Hive.registerAdapter(TodoModelHiveAdapter());
//   await Hive.openBox<TodoModelHive>('Todo');
//   //box.put('a', "value");

//   //await Hive.openBox('')

//   return runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelHiveAdapter());
  await Hive.openBox<TodoModelHive>('Todo');
  return runApp(MyApp());
}

loc() {
  // LocationServices().getPermissionAndGetCurrentLocation();
  // LocationSettings locationSettings = const LocationSettings(
  //     accuracy: LocationAccuracy.high, distanceFilter: 100);
  // Geolocator.getPositionStream(locationSettings: locationSettings)
  //     .listen((value) async {
  //   lat = value.latitude;
  //   long = value.longitude;
  //   await LocationServices().getAddress(lat, long).then((value) {
  //     address = value.first.subLocality!;
  //     roadName = value.first.street!;
  //     countryName = value.first.country!;
  //   });

  //   globalAddress = address;
  //   print("address==============$address");
  //   print("roadName==============$roadName");
  // });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel creatingNotificationChannel =
      AndroidNotificationChannel(
    'foreground_message_id', // id
    'It\'s FOREGROUND SERVICE', // title
    description: 'This channel is used for Local Notification', // description
    importance: Importance.low,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(creatingNotificationChannel);

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
    ),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart, //start e ki ki hobe ta
        isForegroundMode: true, //forground notification on hobe
        initialNotificationContent:
            "This is the first notification in the local notification Portion",
        notificationChannelId: 'foreground_message_id', //channel name
        initialNotificationTitle: 'It\'s FOREGROUND SERVICE',
        foregroundServiceNotificationId: 888),
  );

  service.startService(); // eikhne start hobe
}

void onStart(ServiceInstance serviceInstance) async {
  DartPluginRegistrant.ensureInitialized();
  if (serviceInstance is AndroidServiceInstance) {
    serviceInstance.on('setAsForeground').listen((event) {
      serviceInstance.setAsForegroundService();
    });
    serviceInstance.on('setAsBackground').listen((event) {
      serviceInstance.setAsBackgroundService();
    });

    serviceInstance.on('stopService').listen((event) {
      serviceInstance.stopSelf();
    });
    Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        loc();
        // print("$address $roadName $countryName");
        print("############ Background services is running ################");
        // ignore: unnecessary_type_check
        if (serviceInstance is AndroidServiceInstance) {
          if (await serviceInstance.isForegroundService()) {
            FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                FlutterLocalNotificationsPlugin();
            flutterLocalNotificationsPlugin.show(
                888,
                "location services under working process...",
                // "$roadName ,$globalAddress ,$countryName",
                "body",
                // ignore: prefer_const_constructors
                NotificationDetails(
                    // ignore: prefer_const_constructors
                    android: AndroidNotificationDetails(
                        'foreground_message_id', 'It\'s FOREGROUND SERVICE',
                        icon: 'ic_bg_service_small',
                        playSound: true,
                        enableVibration: true,
                        importance: Importance.high,
                        ongoing: true)));
          }
        }
        serviceInstance.invoke(
          'update',
          {
            "address": address,
            "current_date": DateTime.now().toIso8601String(),
          },
        );
      },
    );

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceModel;
    if (Platform.isAndroid) {
      final matha = await deviceInfoPlugin.androidInfo;
      deviceModel = matha.model;
    }

    serviceInstance.invoke('update', {
      "address": address,
      "current_date": DateTime.now().toIso8601String(),
      "device": deviceModel,
    });
  }
}

// final GoRouter _routes = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (context, state) {
//         return const HomePage();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: '/background',
//           builder: (BuildContext context, GoRouterState state) {
//             return const BackGroundServicesScreen();
//           },
//         ),
//       ],
//     ),
//   ],
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      //home: const HivedatabaseHomeScreen(),
      home: const HomePage(),
    );
  }
}


// loc() async {
//   LocationServices().getPermissionAndGetCurrentLocation();
//   LocationSettings locationSettings = await LocationSettings(
//       accuracy: LocationAccuracy.high, distanceFilter: 100);
//   Geolocator.getPositionStream(locationSettings: locationSettings)
//       .listen((value) async {
//     lat = value.latitude;
//     long = value.longitude;
//     await LocationServices().getAddress(lat, long).then((value) {
//       address = value.first.subLocality!;
//       roadName = value.first.street!;
//       countryName = value.first.country!;
//     });

//     globalAddress = address;
//     print("address==============$address");
//     print("roadName==============$roadName");
//   });
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   const AndroidNotificationChannel creatingNotificationChannel =
//       AndroidNotificationChannel(
//     'foreground_message_id', // id
//     'It\'s FOREGROUND SERVICE', // title
//     description: 'This channel is used for Local Notification', // description
//     importance: Importance.low,
//   );

//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(creatingNotificationChannel);

//   await service.configure(
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//     ),
//     androidConfiguration: AndroidConfiguration(
//         onStart: onStart, //start e ki ki hobe ta
//         isForegroundMode: true, //forground notification on hobe
//         initialNotificationContent:
//             "This is the first notification in the local notification Portion",
//         notificationChannelId: 'foreground_message_id', //channel name
//         initialNotificationTitle: 'It\'s FOREGROUND SERVICE',
//         foregroundServiceNotificationId: 888),
//   );
//   service.startService(); // eikhne start hobe
// }

// void onStart(ServiceInstance serviceInstance) async {
//   DartPluginRegistrant.ensureInitialized();
//   if (serviceInstance is AndroidServiceInstance) {
//     serviceInstance.on('setAsForeground').listen((event) {
//       serviceInstance.setAsForegroundService();
//     });
//     serviceInstance.on('setAsBackground').listen((event) {
//       serviceInstance.setAsBackgroundService();
//     });

//     serviceInstance.on('stopService').listen((event) {
//       serviceInstance.stopSelf();
//     });
//     Timer.periodic(
//       const Duration(seconds: 2),
//       (timer) async {
//         loc();
//         print("$address $roadName $countryName");
//         if (serviceInstance is AndroidServiceInstance) {
//           if (await serviceInstance.isForegroundService()) {
//             FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//                 FlutterLocalNotificationsPlugin();
//             flutterLocalNotificationsPlugin.show(
//                 888,
//                 "$roadName ,$globalAddress ,$countryName",
//                 "body",
//                 // ignore: prefer_const_constructors
//                 NotificationDetails(
//                     // ignore: prefer_const_constructors
//                     android: AndroidNotificationDetails(
//                         'foreground_message_id', 'It\'s FOREGROUND SERVICE',
//                         icon: 'ic_bg_service_small',
//                         playSound: true,
//                         enableVibration: true,
//                         importance: Importance.high,
//                         ongoing: true)));
//           }
//         }
//         serviceInstance.invoke(
//           'update',
//           {
//             "address": address,
//             "current_date": DateTime.now().toIso8601String(),
//           },
//         );
//       },
//     );

//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     String? deviceModel;
//     if (Platform.isAndroid) {
//       final matha = await deviceInfoPlugin.androidInfo;
//       deviceModel = matha.model;
//     }

//     serviceInstance.invoke('update', {
//       "address": address,
//       "current_date": DateTime.now().toIso8601String(),
//       "device": deviceModel,
//     });
//   }
// }

// // final GoRouter _routes = GoRouter(
// //   routes: <RouteBase>[
// //     GoRoute(
// //       path: '/',
// //       builder: (context, state) {
// //         return const HomePage();
// //       },
// //       routes: <RouteBase>[
// //         GoRoute(
// //           path: '/background',
// //           builder: (BuildContext context, GoRouterState state) {
// //             return const BackGroundServicesScreen();
// //           },
// //         ),
// //       ],
// //     ),
// //   ],
// // );

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const HomePage(),
//     );
//   }
// }
