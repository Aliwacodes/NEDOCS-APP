import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'This app helps calculate the National Emergency Department Overcrowding Score (NEDOCS) to assist in managing emergency department resources efficiently.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
