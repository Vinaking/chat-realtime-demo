import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:socket_demo/foundation/msg_widget/other_msg_widget.dart';
import 'package:socket_demo/foundation/msg_widget/own_msg_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'msg_model.dart';


class GroupPage extends StatefulWidget {
  final String userID;
  final String name;
  const GroupPage({Key? key,required this.userID, required this.name}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  IO.Socket? socket;
  List<MsgModel> listMsg = [];
  TextEditingController msgController = TextEditingController();
  late ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connect();
  }

  void scrollToBottom() {
    final bottomOffset = scrollController.position.maxScrollExtent;
    scrollController.animateTo(
      bottomOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void connect() {
    socket = IO.io("https://chat-server-demo.onrender.com", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket!.connect();
    socket!.onConnect((_) {
      print("connect into client aa");
      socket!.on("sendMsgServer", (data) {
        print(data);
        if (mounted) {
          setState(() {
            print("set setState");
            listMsg.add(MsgModel(
                userID: data["userID"],
                msg: data["msg"],
                type: data["type"],
                sender: data["sender"]));
          });
          scrollToBottom();
        }
      });
    });
  }

  void sendMsg(String msg, String userID, String sender) {
    socket!.emit("sendMsg", {"userID": userID, "type": "ownMsg", "msg": msg, "sender": sender});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anomynous group"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                  itemCount: listMsg.length + 1,
                  itemBuilder: (context, index) {
                    if (index == listMsg.length) {
                      return Container(
                        height: 70,
                      );
                    }
                    MsgModel msgModel = listMsg[index];
                    print("listview: ${msgModel.userID}");
                    if (msgModel.userID == widget.userID) {
                      return OwnMsgWidget(sender: msgModel.sender, msg: msgModel.msg);
                    }
                    return OtherMsgWidget(sender: msgModel.sender, msg: msgModel.msg);
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: msgController,
                  decoration: InputDecoration(
                      hintText: "Type here...",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      suffixIcon: IconButton(
                          onPressed: () {
                            String msg = msgController.text;
                            if (msg.isNotEmpty) {
                              sendMsg(msg, widget.userID, widget.name);
                              msgController.clear();
                            }
                          },
                          icon: const Icon(Icons.send))),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
