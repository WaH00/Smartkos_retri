import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.onRetry,
    required this.onReturnToSearch,
    super.key,
  });

  final ChatMessageModel message;
  final VoidCallback onRetry;
  final VoidCallback onReturnToSearch;

  @override
  Widget build(BuildContext context) {
    final action = message.suggestedAction;
    final showRetry = !message.isUser && action == 'RETRY';
    final showSearch =
        !message.isUser &&
        (action == 'SHOW_SEARCH_RESULTS' || action == 'REDIRECT_TO_SEARCH');

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.84,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: message.isUser
                ? AppTheme.primary
                : message.isError
                ? const Color(0xFFFFF3F2)
                : const Color(0xFFF0F5FA),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(message.isUser ? 16 : 4),
              bottomRight: Radius.circular(message.isUser ? 4 : 16),
            ),
            border: message.isError
                ? Border.all(color: const Color(0xFFFFC9C5))
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.isUser)
                  Text(
                    message.text,
                    key: const ValueKey('user-message-text'),
                    style: const TextStyle(color: Colors.white, height: 1.4),
                  )
                else
                  MarkdownBody(
                    key: const ValueKey('ai-message-markdown'),
                    data: message.text.trim().isEmpty
                        ? 'Maaf, respons Makelar AI kosong.'
                        : message.text.trim(),
                    selectable: true,
                    shrinkWrap: true,
                    styleSheet: _markdownStyle(context),
                  ),
                if (showRetry) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: onRetry,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Coba lagi'),
                  ),
                ],
                if (showSearch) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: onReturnToSearch,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.search_rounded, size: 18),
                    label: Text(
                      action == 'SHOW_SEARCH_RESULTS'
                          ? 'Kembali ke hasil pencarian'
                          : 'Kembali ke pencarian',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle(BuildContext context) {
    final theme = Theme.of(context);
    final baseText = theme.textTheme.bodyMedium?.copyWith(
      color: AppTheme.textPrimary,
      fontSize: 14,
      height: 1.45,
    );

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: baseText,
      pPadding: const EdgeInsets.only(bottom: 4),
      strong: baseText?.copyWith(fontWeight: FontWeight.w800),
      em: baseText?.copyWith(fontStyle: FontStyle.italic),
      h1: theme.textTheme.titleLarge?.copyWith(
        color: AppTheme.textPrimary,
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w800,
      ),
      h1Padding: const EdgeInsets.only(top: 4, bottom: 6),
      h2: theme.textTheme.titleMedium?.copyWith(
        color: AppTheme.textPrimary,
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w800,
      ),
      h2Padding: const EdgeInsets.only(top: 4, bottom: 6),
      h3: theme.textTheme.titleSmall?.copyWith(
        color: AppTheme.textPrimary,
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w800,
      ),
      h3Padding: const EdgeInsets.only(top: 4, bottom: 5),
      listIndent: 22,
      listBullet: baseText?.copyWith(fontWeight: FontWeight.w700),
      listBulletPadding: const EdgeInsets.only(right: 6),
      blockSpacing: 8,
      blockquote: baseText?.copyWith(color: AppTheme.textSecondary),
      blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
      blockquoteDecoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.07),
        border: const Border(
          left: BorderSide(color: AppTheme.primary, width: 3),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      code: theme.textTheme.bodySmall?.copyWith(
        color: AppTheme.textPrimary,
        fontFamily: 'monospace',
        backgroundColor: AppTheme.primary.withValues(alpha: 0.08),
      ),
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFD9E6F2))),
      ),
    );
  }
}
