import 'package:congressional_app/CongressionalApp/login.dart';
import 'package:congressional_app/blocs/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Google Sign In
import 'package:flutter_signin_button/flutter_signin_button.dart';

//Push Notifications
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'CongressionalApp/home.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',// id
    'High Importance Notifications',//title
    'This channel is used for important notifications',//description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('A background message just showed up : ${message.messageId}');
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Vigilant',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MessageHandler(),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MessageHandler extends StatefulWidget {
  const MessageHandler({Key key}) : super(key: key);

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {

  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    super.initState();
    //Google Sign-In Notification
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      RemoteNotification notification = message.notification;
      AndroidNotification androidNotification = message.notification?.android;
      if(notification != null && androidNotification != null){
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if(notification != null && android != null){
        showDialog(
            context: context,
            builder: (_){
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body),
                    ],
                  ),
                ),
              );
            }
        );
      }
    });
  }

  //Push Notification
  void showNotification(){
    setState(() {
      flutterLocalNotificationsPlugin.show(
        0,
        "ALERT! A Gun Has Been Detected",
        "Your security camera has detected a gun and has sent a snapshot to the Vigilant app",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher'
          )
        ),
      );
    });

  }

  //Google Sign-In
  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(onPressed: showNotification, tooltip: "Ur mum gay", child: Icon(Icons.notifications_active)),
              SignInButton(
                Buttons.Google,
                onPressed: () => authBloc.loginGoogle(),
              ),
              Text("Hellloooooo?")
            ],
          ),
        ));
  }
}
