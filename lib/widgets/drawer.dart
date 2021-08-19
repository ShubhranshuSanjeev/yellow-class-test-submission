import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/custom_user.dart';
import 'package:movie_tracker_application/services/auth.dart';
import 'package:movie_tracker_application/utils/routes.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  final Function callback;

  final AuthService _auth = AuthService();
  DrawerWidget({Key? key, required this.callback}) : super(key: key);

  Widget drawerHeader(user) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: UserAccountsDrawerHeader(
        margin: EdgeInsets.zero,
        accountName: Text(user == null ? 'Anonymous User' : user.uid),
        accountEmail: Text(user == null ? 'N\\A' : user.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.jpg'),
        ),
      ),
    );
  }

  Widget homeTile(context) {
    return ListTile(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.homeRoute);
        callback();
      },
      leading: Icon(
        CupertinoIcons.home,
        color: Colors.white,
      ),
      title: Text(
        "Home",
        textScaleFactor: 1.2,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget addMovieTile(context) {
    return ListTile(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.addMovieRoute);
        callback();
      },
      leading: Icon(
        CupertinoIcons.add_circled,
        color: Colors.white,
      ),
      title: Text(
        "Add Movie",
        textScaleFactor: 1.2,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget drawerButton(context, user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 65),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        elevation: 2,
        child: InkWell(
          focusColor: Colors.black,
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (user == null) {
              Navigator.pushNamed(context, AppRoutes.loginRoute);
            } else {
              _auth.signOut();
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 100,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              user == null ? "Login" : "Sign out",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(user),
            homeTile(context),
            addMovieTile(context),
            SizedBox(
              height: 50,
            ),
            drawerButton(context, user),
          ],
        ),
      ),
    );
  }
}
