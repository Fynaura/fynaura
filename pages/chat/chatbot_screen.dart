// lib/pages/chat/chatbot_screen.dart

import 'package:flutter/material.dart';
import 'package:fynaura/models/chat_message.dart';
import 'package:fynaura/services/gemini_studio_service.dart'; // Updated import
import 'package:intl/intl.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GeminiStudioService _geminiService = GeminiStudioService(); // Updated service
  bool _isTyping = false;

  // Define app's color palette to match rest of app
  static const Color primaryColor = Color(0xFF254e7a);
  static const Color accentColor = Color(0xFF85c1e5);
  static const Color lightBgColor = Color(0xFFEBF1FD);
  static const Color whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Add initial welcome message from chatbot
    _messages.add(
      ChatMessage(
        text: "Hello! I'm your financial assistant. How can I help you today?",
        isUserMessage: false,
      ),
    );
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUserMessage: true,
      ));
      _isTyping = true;
    });

    // Scroll to bottom
    _scrollToBottom();

    try {
      // Get response from Gemini API
      final response = await _geminiService.sendMessage(text);

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: response,
            isUserMessage: false,
          ));
          _isTyping = false;
        });

        // Scroll to bottom again
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "Sorry, I couldn't process your request. Please try again.",
            isUserMessage: false,
          ));
          _isTyping = false;
        });

        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    // Delay to ensure the list is built
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Financial Assistant',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor.withOpacity(0.05), lightBgColor],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageItem(message);
                },
              ),
            ),
            // Typing indicator
            if (_isTyping)
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    _buildPulsingDot(),
                    SizedBox(width: 5),
                    _buildPulsingDot(delay: 0.3),
                    SizedBox(width: 5),
                    _buildPulsingDot(delay: 0.6),
                  ],
                ),
              ),
            // Input area
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about your finances...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: lightBgColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: whiteColor),
                      onPressed: () => _handleSubmitted(_textController.text),
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

  Widget _buildPulsingDot({double delay = 0.0}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: (value + delay) % 1.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    final isUser = message.isUserMessage;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? primaryColor : accentColor,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? Radius.circular(16) : Radius.circular(0),
                  bottomRight: isUser ? Radius.circular(0) : Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: isUser ? whiteColor : Colors.black.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isUser
                            ? whiteColor.withOpacity(0.7)
                            : Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: accentColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.assistant,
          color: whiteColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: whiteColor,
          size: 20,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}