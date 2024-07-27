
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatTile extends StatelessWidget {
  final   userProfile;
  final Function ontap;
  ChatTile({super.key, required this.userProfile, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: ListTile(
        dense: false,
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
          userProfile.pfpURL!,
        ),),
        title: Text(userProfile.name!),
      ),
    );
  }
}
