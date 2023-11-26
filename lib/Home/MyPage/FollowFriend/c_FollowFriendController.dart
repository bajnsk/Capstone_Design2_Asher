import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:capstone/Home/DetailPage/c_DetailPageController.dart';

class FollowFriendController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String feedId = DetailPageController.getFeedID;

  Future<void> followToFriend(List<String> selectedFriendUids) async {
    try {
      // Iterate through selected friend Uids
      for (String friendUid in selectedFriendUids) {
        // Create a reference to the friend's document
        DocumentReference friendDocRef =
            _firestore.collection('users').doc(friendUid);

        // Update the 'followedFeed' field with feedId
        await friendDocRef.set(
          {
            'followedFeed': FieldValue.arrayUnion([feedId]),
          },
          SetOptions(merge: true),
        );
      }
    } catch (error) {
      print('Error following to friend: $error');
      // Handle the error as needed
    }
  }
}
