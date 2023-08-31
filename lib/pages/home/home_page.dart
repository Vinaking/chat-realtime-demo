import 'package:flutter/material.dart';
import 'package:socket_demo/pages/group/group_page.dart';
import 'package:uuid/uuid.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Chat App")
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Please enter your name"),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return "User must have proper name";
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red
                          ),
                        )
                    ),
                    TextButton(
                        onPressed: () {
                          print(nameController.text);
                          if (!formKey.currentState!.validate()) return;
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupPage(
                                    userID: const Uuid().v1(),
                                    name: nameController.text,
                                  )
                              )
                          );
                        },
                        child: const Text(
                          "Enter",
                          style: TextStyle(fontSize: 18),
                        )
                    )
                  ],
                )
            );
          },
          child: const Text(
            "Initial Group chat",
            style: TextStyle(
                color: Colors.teal,
                fontSize: 16
            )
          )
        ),
      ),
    );
  }
}