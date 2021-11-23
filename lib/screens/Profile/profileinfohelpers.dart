import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileInfoHelpers with ChangeNotifier {
  Widget postText(BuildContext context, userData, String docName) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userData)
            .collection(docName)
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Text(
              snapshot.data!.docs.length.toString(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            );
          }
        });
  }
}
