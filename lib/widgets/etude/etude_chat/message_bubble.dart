import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final DateTime date;
  // final String userImage;

  const MessageBubble(
      this.message, this.username, this.isMe, this.date, this.key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: !isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
              ),
              width: 150,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1!.color,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1!.color,
                    ),
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                  ),
                  Text(
                    DateFormat("dd MMM HH:mm").format(date),
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1!.color,
                    ),
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
        // Positioned(
        //   right: isMe ? 140 : null,
        //   left: isMe ? null : 140,
        //   top: -10,
        //   child: CircleAvatar(
        //     backgroundImage: NetworkImage(userImage),
        //   ),
        // ),
      ],
      overflow: Overflow.visible,
    );
  }
}
