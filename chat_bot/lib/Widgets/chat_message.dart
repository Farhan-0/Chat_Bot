import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;
  // final bool isImage;

  const ChatMessage({
    super.key,
    required this.text,
    required this.sender,
    // this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    const height = 48.0;
    const width = 48.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500] as Color,
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 3.5,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
            Container(
              height: height / 1.8,
              width: width / 1.8,
              // color: Colors.blue,
              child: Image.asset(
                sender == 'user'
                    ? 'assets/Icons/user.png'
                    : 'assets/Icons/robot.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                    0.1,
                    0.9,
                  ],
                  colors: sender == 'user'
                      ? [Colors.indigo, Colors.cyan]
                      : [Colors.purple, Colors.blue],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: Colors.blueGrey.withOpacity(0.85),
                  ),
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text.trim(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    ).py8();
  }
}
