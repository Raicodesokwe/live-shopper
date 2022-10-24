import 'package:flutter/material.dart';
import 'package:liveshopper/widgets/background_neon.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundNeon(
      child: Center(
        child: Text(
          'Messages page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
