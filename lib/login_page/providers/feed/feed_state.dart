enum FeedStatus {
  init,
  submitting,
  success,
  error
}

class FeedState {
  final FeedState feedState;

  const FeedState({
    required this.feedState,
  });

  factory FeedState.init() {
    return FeedState(
      feedState: FeedState.init
    );
  }

  FeedState copyWith({
    FeedState? feedState,
  }) {
    return FeedState(
      feedState: feedState ?? this.feedState,
    );
  }
}