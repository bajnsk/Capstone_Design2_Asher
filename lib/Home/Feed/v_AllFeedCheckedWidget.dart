import 'package:flutter/material.dart';

class CheckAnimationWidget extends StatefulWidget {
  @override
  _CheckAnimationWidgetState createState() => _CheckAnimationWidgetState();
}

class _CheckAnimationWidgetState extends State<CheckAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    // 아이콘 애니메이션이 반복되도록 설정
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * 3.141592,
          child: Icon(
            Icons.check_circle,
            color: Colors.blueAccent,
            size: 48,
          ),
        );
      },
    );
  }
}

class AllFeedsCheckedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CheckAnimationWidget(),
          SizedBox(height: 8),
          Text(
            "모든 피드를 확인하셨습니다.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
