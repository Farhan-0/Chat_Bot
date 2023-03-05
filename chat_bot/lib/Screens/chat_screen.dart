import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../Widgets/chat_message.dart';
import '../Widgets/three_dots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const apiKey = "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";
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  StreamSubscription? _subscription;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // chatGPT = ChatGPT.instance.builder(
    //   "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",
    // );
    _isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription?.cancel();
    super.dispose();
  }

  Future<String> generateResponse(String prompt) async {
    const apiKey = "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";

    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $apiKey"
      },
      body: json.encode({
        // "model": "text-davinci-003",
        // "prompt": prompt,
        // 'temperature': 0,
        // 'max_tokens': 2000,
        // 'top_p': 1,
        // 'frequency_penalty': 0.0,
        // 'presence_penalty': 0.0,

        "model": "text-davinci-003",
        "prompt": prompt,
        // "Marv is a chatbot that reluctantly answers questions with sarcastic responses:\n\nYou: How many pounds are in a kilogram?\nMarv: This again? There are 2.2 pounds in a kilogram. Please make a note of this.\nYou: What does HTML stand for?\nMarv: Was Google too busy? Hypertext Markup Language. The T is for try to ask better questions in the future.\nYou: When did the first airplane fly?\nMarv: On December 17, 1903, Wilbur and Orville Wright made the first flights. I wish they’d come and take me away.\nYou: What is the meaning of life?\nMarv: I’m not sure. I’ll ask my friend Google.\nYou: What time is it?\nMarv:",
        "temperature": 0.5,
        "max_tokens": 4000,
        "top_p": 0.3,
        "frequency_penalty": 0.5,
        "presence_penalty": 0.0,
      }),
    );
    print('response => ');
    print(response.body);

    // Do something with the response
    try {
      Map<String, dynamic> newresponse = jsonDecode(response.body);

      return newresponse['choices'][0]['text'];
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Error Occurred :(',
          ),
          content: const Text(
              'Sorry. The Model was currently overloaded with other requests. Please Retry.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      );
    }
    return 'ERROR';
  }

  void _sendMessage() async {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: _controller.text,
          sender: "user",
        ),
      );
      // _messages.add(
      //   ChatMessage(
      //     text: _controller.text,
      //     sender: "user",
      //   ),
      // );
      _isLoading = true;
    });
    var input = _controller.text;
    _controller.clear();
    //scroll
    try {
      generateResponse(input).then((value) {
        setState(() {
          _isLoading = false;
          if (value != 'ERROR') {
            _messages.insert(
              0,
              ChatMessage(
                text: value,
                sender: "bot",
              ),
            );
          }
        });
        if (value == 'ERROR') {
          print('ERROR');
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Error Occurred :(',
          ),
          content: const Text(
              'Sorry. The Model was currently overloaded with other requests.\nPlease Retry.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    _controller.clear();
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: Colors.indigo,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send a Message'),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            // onPressed: () => _sendMessage(),
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.send_rounded,
              color: Colors.cyan,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          'Chat BOT',
          style: TextStyle(color: Colors.white, fontFamily: 'Roboto-Condensed'),
        ),
        // backgroundColor: const Color.fromARGB(255, 52, 130, 169),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.9],
              colors: <Color>[
                Colors.indigoAccent,
                Colors.cyan,
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            if (_isLoading) const ThreeDots(),
            // const Divider(),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              height: 60,
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(8, 10),
                    blurRadius: 20,
                    color: Colors.blueGrey.shade400,
                  ),
                ],
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}
