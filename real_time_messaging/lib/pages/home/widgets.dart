import 'package:flutter/material.dart';

import 'package:real_time_messaging/utils/sizeconfig.dart';

Widget buildDrawerWidget({@required Function handleSignout, @required BuildContext context}) {
  return Drawer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
        ),
        ListTile(
          title: Text('Edit Profile'),
          onTap: () {
            Navigator.of(context).pushNamed('/editProfile');
          },
        ),
        ListTile(
          title: Text('Signout'),
          onTap: handleSignout,
        ),
      ],
    ),
  );
}
