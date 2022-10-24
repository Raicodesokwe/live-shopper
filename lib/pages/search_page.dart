import 'package:flutter/material.dart';
import 'package:liveshopper/widgets/background_neon.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundNeon(
      child: Center(
        child: Text(
          'Search page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
