import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/api/api_client.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/models/kos_result_model.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/search_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../saved/controllers/saved_controller.dart';

class DetailKosController extends GetxController {
  DetailKosController(this._repository, this._chatRepository);

  final SearchRepository _repository;
  final ChatRepository _chatRepository;

  final kos = Rxn<KosResultModel>();
  final userLatitude = RxnDouble();
  final userLongitude = RxnDouble();
  final chatMessages = <ChatMessageModel>[].obs;
  final isSendingMessage = false.obs;
  final chatTextController = TextEditingController();
  final chatScrollController = ScrollController();

  late final String chatSessionId;
  String? _lastFailedMessage;

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    final kosId = kos.value?.idKos ?? 0;
    chatSessionId =
        'detail-kos-$kosId-${DateTime.now().microsecondsSinceEpoch}';
    chatMessages.add(
      ChatMessageModel(
        text:
            'Halo! Saya Makelar AI. Tanyakan apa saja tentang kos ini atau rekomendasi kos lain yang sesuai kebutuhanmu.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _readArguments() {
    final argument = Get.arguments;
    if (argument is Map) {
      final kosArgument = argument['kos'];
      final latitude = argument['userLatitude'];
      final longitude = argument['userLongitude'];
      if (kosArgument is KosResultModel) kos.value = kosArgument;
      if (latitude is num) userLatitude.value = latitude.toDouble();
      if (longitude is num) userLongitude.value = longitude.toDouble();
    } else if (argument is KosResultModel) {
      kos.value = argument;
    }

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      userLatitude.value ??= home.selectedLatitude.value;
      userLongitude.value ??= home.selectedLongitude.value;
    }
  }

  Future<void> sendChatMessage() async {
    final message = chatTextController.text.trim();
    if (message.isEmpty || isSendingMessage.value) return;
    await _sendMessage(message, addUserMessage: true);
  }

  Future<void> retryLastMessage() async {
    final message = _lastFailedMessage;
    if (message == null || isSendingMessage.value) return;
    await _sendMessage(message, addUserMessage: false);
  }

  Future<void> _sendMessage(
    String message, {
    required bool addUserMessage,
  }) async {
    final latitude = userLatitude.value;
    final longitude = userLongitude.value;
    if (latitude == null || longitude == null) {
      chatMessages.add(
        ChatMessageModel(
          text:
              'Lokasi pencarian belum tersedia. Kembali ke halaman pencarian dan pilih lokasi terlebih dahulu.',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
      _scrollToLatest();
      return;
    }

    if (addUserMessage) {
      chatMessages.add(
        ChatMessageModel(
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      chatTextController.clear();
    }
    isSendingMessage.value = true;
    _scrollToLatest();

    try {
      final response = await _chatRepository.sendMessage(
        sessionId: chatSessionId,
        message: message,
        userLatitude: latitude,
        userLongitude: longitude,
      );
      if (isClosed) return;
      _lastFailedMessage = response.suggestedAction == 'RETRY' ? message : null;
      chatMessages.add(
        ChatMessageModel(
          text: response.reply,
          isUser: false,
          timestamp: DateTime.now(),
          suggestedAction: response.suggestedAction,
        ),
      );
    } on ApiException catch (error, stackTrace) {
      _handleChatError(message, error, stackTrace);
    } catch (error, stackTrace) {
      _handleChatError(message, error, stackTrace);
    } finally {
      if (!isClosed) {
        isSendingMessage.value = false;
        _scrollToLatest();
      }
    }
  }

  void _handleChatError(String message, Object error, StackTrace stackTrace) {
    if (isClosed) return;
    _lastFailedMessage = message;
    debugPrint('Makelar AI request failed: ${error.runtimeType}');
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
    chatMessages.add(
      ChatMessageModel(
        text: 'Maaf, Makelar AI belum dapat merespons. Silakan coba lagi.',
        isUser: false,
        timestamp: DateTime.now(),
        isError: true,
        suggestedAction: 'RETRY',
      ),
    );
  }

  void returnToSearch() {
    if (Get.isBottomSheetOpen ?? false) Get.back<void>();
    Get.back<void>();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed || !chatScrollController.hasClients) return;
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void toggleFavorite() {
    final current = kos.value;
    if (current == null) return;
    final updated = _repository.toggleFavorite(current);
    kos.value = updated;

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      final index = home.results.indexWhere(
        (item) => item.idKos == updated.idKos,
      );
      if (index != -1) home.results[index] = updated;
    }
    if (Get.isRegistered<SavedController>()) {
      Get.find<SavedController>().loadFavorites();
    }
  }

  void contactOwner() {
    Get.snackbar(
      'Hubungi Pemilik',
      'Fitur kontak pemilik akan tersedia setelah endpoint backend disiapkan.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    chatTextController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}
