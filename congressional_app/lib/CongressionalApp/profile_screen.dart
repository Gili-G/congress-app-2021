import 'package:congressional_app/blocs/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder<User>(
          stream: authBloc.currentUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data.displayName,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 20.0),
                CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data.photoURL.replaceFirst('s96', 's400')),
                  radius: 60,
                ),
                SizedBox(height: 100.0),
                SignInButton(Buttons.Google, text: "Sign Out of Google", onPressed: () => authBloc.logout()
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
