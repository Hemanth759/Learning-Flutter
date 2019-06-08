import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import 'package:real_time_messaging/services/loader.dart';
import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/services/firestoreCRUD.dart';
import 'package:real_time_messaging/services/secureStorageCRUD.dart';
import 'package:real_time_messaging/services/storageIO.dart';

import 'package:real_time_messaging/utils/sizeconfig.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, String> currentUser;

  EditProfilePage({Key key, @required this.currentUser});

  @override
  State<StatefulWidget> createState() {
    return _EditState();
  }
}

class _EditState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading;

  File avaterImage;

  String userId;
  String imgLoc;
  String name;
  String aboutMe;

  @override
  void initState() {
    _isLoading = false;

    if (widget.currentUser == null) {
      debugPrint('Error uccured in receving user info for edit profile page');
    } else {
      setState(() {
        this.userId = widget.currentUser['userId'] ?? '';
        this.imgLoc = widget.currentUser['imgLoc'] ?? '';
        this.name = widget.currentUser['name'] ?? '';
        this.aboutMe = widget.currentUser['aboutMe'] ?? '';
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Edit Profile'),
          ),
          body: _isLoading == true
              ? Loader()
              : Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // avatar here
                        Container(
                          height: SizeConfig.blockSizeVertical * 20,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          child: Stack(
                            fit: StackFit.loose,
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                child: Material(
                                  child: CachedNetworkImage(
                                    height: SizeConfig.blockSizeVertical * 30,
                                    fit: BoxFit.cover,
                                    imageUrl: imgLoc,
                                    placeholder: (content, url) => Loader(),
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 30)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 15,
                                  left: SizeConfig.blockSizeHorizontal * 32
                                ),
                                child: Container(
                                  child: IconButton(
                                    alignment: Alignment.center,
                                    icon: Icon(
                                      Icons.camera_enhance,
                                      size: SizeConfig.blockSizeHorizontal * 8,
                                    ),
                                    onPressed: _updateImg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // nickname here
                        Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 5),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  // name
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal * 75,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      keyboardAppearance: Brightness.dark,
                                      autocorrect: true,
                                      initialValue: this.name,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Name can\'t be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        this.name = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Display name',
                                        hintText: 'Your name for example',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none
                                        ),
                                      ),
                                    ),
                                  ),

                                  // about me
                                  Container(
                                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                                    width: SizeConfig.blockSizeHorizontal * 75,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      keyboardAppearance: Brightness.dark,
                                      autocorrect: true,
                                      initialValue: this.aboutMe,
                                      validator: (value) {
                                        return null;
                                      },
                                      onSaved: (value) {
                                        this.aboutMe = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'About Me',
                                        hintText: 'Describe yourself in few lines',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),

                        Expanded(
                          child: Container(),
                        ),

                        // update button
                        Container(
                          child: RaisedButton(
                            child: Text('Update'),
                            onPressed: _updateUser,
                          ),
                        ),

                        Expanded(
                          child: Container(),
                        )
                      ],
                    ),
                  ))),
      onWillPop: goBack,
    );
  }

  /// triggers the update image method
  Future<void> _updateImg() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    debugPrint('image is: ${image.path}');
    if(image != null) {
      setState(() {
       _isLoading = true;
       avaterImage = image;
      });

      final String downloadUri = await StorageIO().uploadImage(userId: userId, imageFile: image);
      final User user = User(
        userId: userId,
        aboutMe: aboutMe,
        imgLoc: downloadUri,
        name: name,
      );
      
      imgLoc = downloadUri;
      await FireStoreCRUD().updateUserInfo(user);
      await SecureStorage().addData(userId: userId);

      setState(() {
       _isLoading = false;
      });
    }
  }

  /// validates the form and returns true if 
  /// the form is valid
  bool _validateAndSave() {
    final FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  /// updates the user info to firestore database
  Future<void> _updateUser() async {
    setState(() {
     _isLoading = true; 
    });

    if(_validateAndSave()) {
      final User user = User(
        name: name,
        aboutMe: aboutMe,
        imgLoc: imgLoc,
        userId: userId,
      );

      // to update the firestore and local storage
      await FireStoreCRUD().updateUserInfo(user);
      await SecureStorage().addData(userId: userId);
    }

    setState(() {
     _isLoading = false; 
    });
  }

  /// returns to previous page
  Future<bool> goBack() async {
    return Navigator.of(context).pop();
  }
}
