import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {

  String location; //location name for the UI
  String time; //the time in that location
  String flag; //url to an asset flag icon
  String url; //location url for api endpoint

  WorldTime({ this.location, this.flag, this.url});

  Future<void> getTime() async {

    //make the request

    Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
    Map data = jsonDecode(response.body);
    //print(data);

    //get properties from data
    String dateTime = data['datetime'];
    String offSet = data['utc_offset'].substring(0,3);
    //print(dateTime);
    //print(offSet);

    //create a DateTime object
    DateTime now = DateTime.parse(dateTime);
    now = now.add(Duration(hours: int.parse(offSet)));

    //set the time property
    time = now.toString();

  }

}