// lib/models/chat_message.dart

class ChatMessage {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}