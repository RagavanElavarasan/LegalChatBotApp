import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatInterfacePage extends StatefulWidget {
  const ChatInterfacePage({super.key});

  @override
  _ChatInterfacePageState createState() => _ChatInterfacePageState();
}

class _ChatInterfacePageState extends State<ChatInterfacePage> {
  final TextEditingController _userInputController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  bool showPrompts = true;
  String errorMessage = '';

  // Example prompts
  final List<String> examplePrompts = [
    "தடை செய்யப்பட்ட பகுதிகளுக்கு செல்வதற்காக ...",
    "அண்டை நாட்டின் எல்லையில் ...",
    "ஒரு பொது ஊழியர் ...",
    "இந்திய அரசாங்கத்தின் மீது ..."
  ];

  // Function to send message to the backend
  Future<void> _sendMessage(String userInput) async {
    if (userInput.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a scenario';
      });
      return;
    }

    // Add user message to the chat list
    setState(() {
      messages.add({'sender': 'user', 'text': userInput});
      _userInputController.clear();
      showPrompts = false;
      isLoading = true;
      errorMessage = '';
    });

    // Send message to backend
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': userInput}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> botResponse = json.decode(response.body);

        setState(() {
          messages.add({
            'sender': 'bot',
            'text': botResponse['content'] ?? 'No response content',
            'title': botResponse['title'] ?? 'No title',
            'section': botResponse['section'] ?? 'No section',
            'punishment': botResponse['punishment'] ?? 'No punishment'
          });
        });
      } else {
        setState(() {
          errorMessage = 'Error fetching data from the chatbot.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching data from the chatbot.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle prompt click
  void _handlePromptClick(String prompt) {
    _userInputController.text = prompt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Legal Chatbot')),
      body: Column(
        children: [
          // Show example prompts
          if (showPrompts)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Try one of these examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: examplePrompts.map((prompt) {
                      return ElevatedButton(
                        onPressed: () => _handlePromptClick(prompt),
                        child: Text(prompt, textAlign: TextAlign.center),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),

          // Chat history
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isUser)
                          Text(
                            message['text'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        if (!isUser) ...[
                          Text("Title: ${message['title']}"),
                          Text("Section: ${message['section']}"),
                          Text("Punishment: ${message['punishment']}"),
                          const SizedBox(height: 8),
                          Text(message['text'] ?? ''),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // User input and send button
          if (!isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _userInputController,
                      decoration: const InputDecoration(
                        hintText: 'Describe your legal scenario...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _sendMessage(_userInputController.text),
                    child: const Text('Send'),
                  )
                ],
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),

          // Error message
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}