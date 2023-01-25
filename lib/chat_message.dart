import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Container(
        //   margin: const EdgeInsets.only(right: 16),
        //   child: CircleAvatar(child: Text(sender[0])),
        // ),
        Text(sender)
            .text
            .subtitle1(context)
            .make()
            .box
            .color(sender == 'user' ? Vx.green100 : Vx.red100)
            .p16
            .roundedFull
            .alignCenter
            .makeCentered(),
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         sender,
        //         style: Theme.of(context).textTheme.subtitle1,
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(top: 5),
        //         child: Text(text),
        //       )
        //     ],
        //   ),
        // )

        Expanded(
          child: text.trim().text.make().px8(),
        )
      ],
    ).py8();
  }
}
