import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';

import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/services/loader.dart';

import 'package:real_time_messaging/utils/sizeconfig.dart';

Widget buildDrawerWidget(
    {@required Function handleSignout,
    @required BuildContext context,
    @required Map<String, String> currentUser}) {
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
            Navigator.of(context)
                .pushNamed('/editProfile', arguments: currentUser);
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

/// builds the listtile for the user
Widget _buildChatView({@required User user, @required Function goToChatPage}) {
  return ListTile(
    leading: CircleAvatar(
      child: CachedNetworkImage(
        imageUrl: user.imgLoc,
        alignment: Alignment.center,
        placeholder: (context, _) => Loader(),
      ),
    ),
    title: Text(
      user.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    onTap: () {
      goToChatPage(
        user: user,
      );
    },
  );
}

/// builds the entire user chat list
Widget buildChatList(
    {@required User currentUser,
    @required List<User> userList,
    @required Function goToChatPage,
    @required ScrollController scrollController}) {
  return ListView.builder(
    itemCount: userList.length,
    controller: scrollController,
    itemBuilder: (context, index) {
      return currentUser.userId != userList[index].userId ? _buildChatView(
        user: userList[index],
        goToChatPage: goToChatPage,
      ) : Container();
    },
  );
}
