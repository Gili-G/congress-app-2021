import 'package:flutter/material.dart';
import 'package:congressional_app/services/world_time.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  String time = 'loading';

  void setUpWorldTime() async{
    WorldTime instance = WorldTime(location: 'New York', flag: 'America.png', url: 'America/New_York');
    await instance.getTime();
    print(instance.time);
    setState(() {
      time = instance.time;
    });
  }


  @override
  void initState() {
    super.initState();
    setUpWorldTime();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Text(time),
      ),

    );
  }
}
