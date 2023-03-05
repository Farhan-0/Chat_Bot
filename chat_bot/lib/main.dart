import 'package:chat_bot/Screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.grey[100],
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Roboto-Condensed',

        // textTheme:
      ),
      home: ChatScreen(),
    );
  }
}
