import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class FeedRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const FeedRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<void> uploadFeed({
    required List<String> files,
    required String desc,
    required String uid,
}) async {
    String feedId =  Uuid().v1();

    //   firebase 문서 참조
    DocumentReference<Map<String, dynamic>> feedDocsRef = firebaseFirestore.collection('feeds').doc(feedId);

    DocumentReference<Map<String, dynamic>> userDocRef = firebaseFirestore.collection('users').doc(uid);
    //  storage 참조
    Reference ref = firebaseStorage.ref().child('feeds').child(feedId);

    List<String> imageUrls = await Future.wait(files.map((e) async {
      String imageId = Uuid().v1();
      TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
      return await taskSnapshot.ref.getDownloadURL();
    }).toList());

    await feedDocsRef.set({
      'uid': uid,
      'feedId': feedId,
      'desc': desc,
      'imageUrls': imageUrls,
      'likes': [],
      'likeCount': 0,
      'commentCount': 0,
      'createAt': Timestamp.now(),
      'writer': userDocRef,
    });
  }
}