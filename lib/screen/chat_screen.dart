import 'dart:async';

import 'package:chat_gpt/widgets/three_dots.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? _chatGPT;
  bool _isTyping = false;

  StreamSubscription? _subscription;

  _messageTextField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(hintText: "Ask Question"),
          ),
        ),
        IconButton(
            onPressed: () {
              _sendMessage();
            },
            icon: const Icon(Icons.send))
      ],
    ).px16();
  }

  @override
  void initState() {
    // TODO: implement initState
    _chatGPT = ChatGPT.instance;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message =
        ChatMessage(text: _textController.text, sender: 'user');

    setState(() {
      _isTyping = true;
      _messages.insert(0, message);
    });

    _textController.clear();

    final request = CompleteReq(prompt: message.text, model: kTranslateModelV3);

    _subscription = _chatGPT!
        .builder(
          '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',
          orgId: "",
        )
        .onCompleteStream(request: request)
        .listen((res) {
      print(res!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: res!.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat GPT'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return _messages[index];
                },
                itemCount: _messages.length,
              ).px12(),
            ),
            if (_isTyping) ThreeDots(),
            const Divider(
              color: Colors.black,
            ),
            Container(
              decoration: const BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  // color: Colors.red,
                  ),
              child: _messageTextField(),
            )
          ],
        ),
      ),
    );
  }
}
