import 'package:flutter/material.dart';

class ChatInterfacePage extends StatefulWidget {
  const ChatInterfacePage({super.key});

  @override
  State<ChatInterfacePage> createState() => _ChatInterfacePageState();
}

class _ChatInterfacePageState extends State<ChatInterfacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Copsify AI"),
      ),
      body: Center(
        child: Text("Login Successfull")
      )
    );
  }
}