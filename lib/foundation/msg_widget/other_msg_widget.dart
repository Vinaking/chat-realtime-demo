import 'package:flutter/material.dart';

class OtherMsgWidget extends StatelessWidget {
  final String sender;
  final String msg;

  const OtherMsgWidget({Key? key, required this.sender, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45
        ),
        child: Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    sender,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )),
                Text(
                    msg,
                    style: const TextStyle(
                        fontSize: 16
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
