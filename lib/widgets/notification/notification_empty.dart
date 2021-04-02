import 'package:flutter/material.dart';

class NotificationEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 30),
        Text(
          "Şimdilik burası boş",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        SizedBox(height: 50),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: NetworkImage(
              "https://media.giphy.com/media/YOqgY2wQazNKleTJ5D/giphy.gif",
            ),
          ),
        ),
      ],
    );
  }
}
