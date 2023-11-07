import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:capstone/login_page/providers/feed/feed_state.dart';
import 'package:capstone/login_page/repositories/feed_repository.dart';
import 'package:provider/provider.dart';



class FeedProvider extends StateNotifier<FeedState> {
  FeedProvider() : super(FeedState.init());

  uploadFeed({
    required List<String> files,
    required String desc,
    required String uid,
  }) async {
    String uid = read<User>().uid;
    await read<FeedRepository>().uploadFeed(files: files, desc: desc, uid: uid);
  }
}