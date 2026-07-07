class ChatResponseModel {
  const ChatResponseModel({
    required this.reply,
    required this.isKosRelated,
    required this.suggestedAction,
  });

  final String reply;
  final bool isKosRelated;
  final String suggestedAction;

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    final rawReply = json['reply']?.toString().trim() ?? '';
    final rawRelated = json['is_kos_related'];
    final rawAction = json['suggested_action']?.toString().toUpperCase();
    const knownActions = {
      'NONE',
      'RETRY',
      'SHOW_SEARCH_RESULTS',
      'REDIRECT_TO_SEARCH',
    };

    return ChatResponseModel(
      reply: rawReply.isEmpty
          ? 'Maaf, Makelar AI belum memiliki jawaban untuk pertanyaan itu.'
          : rawReply,
      isKosRelated: rawRelated is bool ? rawRelated : true,
      suggestedAction: knownActions.contains(rawAction) ? rawAction! : 'NONE',
    );
  }
}
