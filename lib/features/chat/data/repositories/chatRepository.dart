import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/api.dart';
=======
import 'package:madares_app_teacher/core/utils/api.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

import 'package:flutter/foundation.dart';

import '../../../../core/utils/constants.dart';
import '../models/chatMessage.dart';
import '../models/chatUser.dart';

class ChatRepository {
  Future<Map<String, dynamic>> fetchChatUsers(
      {required int offset,
      required bool isParent,
<<<<<<< HEAD
      String? searchString}) async {
=======
      String? searchString}) async
  {
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    try {
      final response = await Api.get(
        url: Api.getChatUsers,
        useAuthToken: true,
        queryParameters: {
          "offset": offset,
          "limit": offsetLimitPaginationAPIDefaultItemFetchLimit,
          "isParent": isParent ? 1 : 0,
          if (searchString != null) "search": searchString
        },
      );
<<<<<<< HEAD
=======
      print("ChatRepositoryRequest======>fetchChatUsers");
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

      List<ChatUser> chatUsers = [];

      for (int i = 0; i < response['data']['items'].length; i++) {
        chatUsers.add(ChatUser.fromJsonAPI(response['data']['items'][i]));
      }

      return {
        "chatUsers": chatUsers,
        "totalItems": response['data']['total_items'] ?? 1,
        "totalUnreadUsers": response['data']['total_unread_users'] ?? 0,
      };
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      throw ApiException(error.toString());
    }
  }

  Future<Map<String, dynamic>> fetchChatMessages(
<<<<<<< HEAD
      {required int offset, required String chatUserId}) async {
=======
      {required int offset, required String chatUserId}) async
  {
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    try {
      final response = await Api.post(
        url: Api.getChatMessages,
        useAuthToken: true,
        body: {
          "offset": offset,
          "user_id": chatUserId,
          "limit": offsetLimitPaginationAPIDefaultItemFetchLimit
        },
      );
<<<<<<< HEAD
=======
      print("ChatRepositoryRequest======>fetchChatMessages");
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

      List<ChatMessage> chatMessage = [];

      for (int i = 0; i < response['data']['items'].length; i++) {
        chatMessage.add(ChatMessage.fromJsonAPI(response['data']['items'][i]));
      }

      return {
        "chatMessages": chatMessage,
        "totalItems": response['data']['total_items'],
      };
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      throw ApiException(error.toString());
    }
  }

  Future<ChatMessage> sendChatMessage(
      {required String message,
      List<String> filePaths = const [],
<<<<<<< HEAD
      required int receiverId}) async {
=======
      required int receiverId}) async
  {
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    try {
      List<MultipartFile> files = [];
      for (var filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }
      final result = await Api.post(
        body: {
          "receiver_id": receiverId.toString(),
          "message": message,
          if (files.isNotEmpty) "file": files
        },
        url: Api.sendChatMessage,
        useAuthToken: true,
      );
<<<<<<< HEAD
=======
      print("ChatRepositoryRequest======>sendChatMessage");

>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
      return ChatMessage.fromJsonAPI(result['data']);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> readAllMessages({
    required String userId,
<<<<<<< HEAD
  }) async {
=======
  }) async
  {
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    try {
      //this will call API to make all messages read, noting in failure
      await Api.post(
        url: Api.readAllMessages,
        useAuthToken: true,
        body: {
          "user_id": userId,
        },
      );
    } catch (_) {}
  }
}
