import 'package:flutter/material.dart';
import 'package:frontend/screens/signin/signin.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatInterfacePage extends StatefulWidget {
  final String email;
  final String username;
  final String firstLetter;

  const ChatInterfacePage({
    super.key,
    required this.email,
    required this.username,
    required this.firstLetter,
  });

  @override
  _ChatInterfacePageState createState() => _ChatInterfacePageState();
}

class _ChatInterfacePageState extends State<ChatInterfacePage> {
  final TextEditingController _userInputController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  bool showPrompts = true;
  String errorMessage = '';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';

  final List<Map<String, String>> examplePrompts = [
    {
      "text": "இந்தியாவில் கல்வி உரிமைச் சட்டம் (RTE) 2009 இன் சட்ட முக்கியத்துவம் என்ன?",
    },
    {
      "text": "சிறப்புத் திருமணச் சட்டம், 1954ன் கீழ் திருமணத்தைப் பதிவு செய்வதற்கான நடைமுறை என்ன, அது ஏன் முக்கியமானது?",
    },
    {
      "text": "யாராவது உடல் ரீதியான அல்லது உணர்ச்சி ரீதியான துஷ்பிரயோகத்தைப் புகாரளித்தால் காவல்துறையின் பங்கு என்ன?",
    },
    {
      "text": "அரசியல் சட்டத்தின் கீழ் உள்ள கட்சித் தாவல் தடைச் சட்டம் இந்தியாவில் கட்சி அரசியலை எவ்வாறு பாதிக்கிறது?",
    },
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _voiceInput = val.recognizedWords;
          _userInputController.text = _voiceInput;
        }),
        localeId: 'ta_IN',
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Future<void> _sendMessage(String userInput) async {
    if (userInput.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a scenario';
      });
      return;
    }

    setState(() {
      messages.add({'sender': 'user', 'text': userInput});
      _userInputController.clear();
      showPrompts = false;
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': userInput}),
      );

      if (response.statusCode == 200) {
        final botResponse = json.decode(response.body);

        // Handle both list and map types in the response
        if (botResponse is List) {
          // Handle list of responses
          for (var item in botResponse) {
            setState(() {
              messages.add({
                'sender': 'bot',
                'text': item['content'] ?? 'No response content',
                'title': item['title'] ?? 'No title',
                'section': item['section'] ?? 'No section',
                'punishment': item['punishment'] ?? 'No punishment'
              });
            });
          }
        } else if (botResponse is Map) {
          // Handle map response
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
            errorMessage = 'Unexpected response format from the server.';
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Error fetching data from the chatbot. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching data from the chatbot: $error';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handlePromptClick(String prompt) {
    _userInputController.text = prompt;
  }

  Widget _buildPromptContainer(String prompt) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 0.8),
      ),
      child: GestureDetector(
        onTap: () => _handlePromptClick(prompt),
        child: Text(
          prompt,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              SizedBox(
                height: 45,
                width: 45,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo-1.png"),
                  radius: 50,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Copsify", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 3),
                  Row(
                    children: const [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 5,
                      ),
                      SizedBox(width: 5),
                      Text("Always Active",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              )
            ],
          ),
          leading: Builder(
            builder: (context) {
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, color: Colors.black),
                ),
              );
            },
          ),
          actions: [
            PopupMenuButton<String>(
              color: Colors.white,
              icon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 20,
                  child: Text(
                    widget.firstLetter,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
              offset: const Offset(0, 60),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Text(widget.email),
                    ),
                  ),
                  PopupMenuItem<String>(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(() => SigninPage());
                          },
                          icon: const Icon(Icons.logout),
                        ),
                        const Text("Log out"),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          elevation: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.menu)),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFFFF9090),
                    Color(0xFF8F0092),
                  ],
                ).createShader(
                    Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                child: RichText(
                  text: TextSpan(
                    text: "Hello, ",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: widget.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "How can I help you today?",
                style: TextStyle(fontSize: 23, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (showPrompts)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 400,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: examplePrompts.length,
                    itemBuilder: (context, index) {
                      final prompt = examplePrompts[index];
                      return _buildPromptContainer(prompt['text']!);
                    },
                  ),
                ),
              ),
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
            if (isLoading) CircularProgressIndicator(),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userInputController,
                      decoration: InputDecoration(
                        hintText: 'Enter your query here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Colors.black), // Change enabled border color to black
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Colors.black), // Change focused border color to black
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: _isListening ? _stopListening : _startListening,
                            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                            color: _isListening ? Colors.red : Colors.blue,
                            iconSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: () {
                        _sendMessage(_userInputController.text);
                      },
                      icon: Image.asset("assets/images/send1.png"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
