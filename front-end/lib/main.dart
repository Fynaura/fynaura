import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'Messages.dart';  // Assuming this file contains your Message class and MessagesScreen widget

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMBot',
      theme: ThemeData(brightness: Brightness.dark),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController(); // Text controller for user input
  List<Map<String, dynamic>> messages = []; // To hold chat messages

  @override
  void initState() {
    super.initState();
    // Initialize DialogFlowtter instance using the dialog_flow_auth.json file from assets
    DialogFlowtter.fromFile().then((instance) {
      dialogFlowtter = instance;
    }).catchError((error) {
      print("Error initializing DialogFlowtter: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FynAuraBot'),
      ),
      body: Container(
        child: Column(
          children: [
            // Displaying chat messages
            Expanded(child: MessagesScreen(messages: messages)),
            // Text input field for user to type messages
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.deepPurple,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Send button
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear(); // Clear the input field after sending
                    },
                    icon: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Send message to DialogFlowtter
  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      // Add user message to chat
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      // Send the message to DialogFlowtter for response
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      // Check if the response contains a message
      if (response.message == null) return;

      // Add bot response to the chat
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  // Function to add messages to the chat
  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
