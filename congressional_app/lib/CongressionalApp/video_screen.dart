
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  List images = [
      "gunDestination.jpg",
      "asmile.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  ImagePage(value: images[index]),
                        ));
                      },
                      title: Text(images[index]),
                    ),
                  ),
                );
              }
          ),
       ),
    );
  }

}


class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future <dynamic> loadImage(BuildContext context, String Image) async{
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}

class ImagePage extends StatefulWidget {

  String value;
  ImagePage({this.value});

  @override
  _ImagePageState createState() => _ImagePageState(value: value);
}

class _ImagePageState extends State<ImagePage> {

  String value;
  _ImagePageState({this.value});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(context, value),
        builder: (context, snapshot){
          if(snapshot.connectionState ==  ConnectionState.done){
            return Scaffold(
              appBar: AppBar(
                title: Text(value),
                backgroundColor: Colors.indigo[500],
              ),
              body: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.width / 1.2,
                child: Center(child: snapshot.data),
              ),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.width / 1.2,
              child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 50,
                  width: 50,
                ),
              ),
            );
          }

          return Container(
            child: Text("You screwed up"),
          );
        }
    );
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async{
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value) => {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      )
    });
    return image;
  }

}
