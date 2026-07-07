class ChatMessageModel {
  const ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
    this.suggestedAction = 'NONE',
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;
  final String suggestedAction;
}
