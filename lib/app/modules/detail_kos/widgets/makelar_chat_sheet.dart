import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/detail_kos_controller.dart';
import 'chat_message_bubble.dart';

class MakelarChatSheet extends GetView<DetailKosController> {
  const MakelarChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.82,
      alignment: Alignment.bottomCenter,
      child: Material(
        key: const ValueKey('chat-sheet-surface'),
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _Header(onClose: Get.back<void>),
              const Divider(height: 1),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    controller: controller.chatScrollController,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                    itemCount: controller.chatMessages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final message = controller.chatMessages[index];
                      return ChatMessageBubble(
                        message: message,
                        onRetry: controller.retryLastMessage,
                        onReturnToSearch: controller.returnToSearch,
                      );
                    },
                  ),
                ),
              ),
              Obx(
                () => controller.isSendingMessage.value
                    ? const _TypingIndicator()
                    : const SizedBox.shrink(),
              ),
              const Divider(height: 1),
              _ChatInput(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 8, 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Makelar AI',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Asisten pencarian kos kamu',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Tutup chat',
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 10),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 9),
          Text(
            'Makelar AI sedang mengetik...',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller});

  final DetailKosController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSending = controller.isSendingMessage.value;
      return Material(
        key: const ValueKey('chat-input-bar'),
        color: AppTheme.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.chatTextController,
                  enabled: !isSending,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.sendChatMessage(),
                  decoration: InputDecoration(
                    hintText: 'Tanyakan tentang kos...',
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF0F5FA),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: AppTheme.primary,
                        width: 1.3,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: isSending ? null : controller.sendChatMessage,
                tooltip: 'Kirim pesan',
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      );
    });
  }
}
