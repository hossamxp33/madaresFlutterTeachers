<<<<<<< HEAD
import 'package:eschool_teacher/features/holidays/data/models/holiday.dart';
=======
import 'package:madares_app_teacher/features/holidays/data/models/holiday.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/foundation.dart';

import '../utils/api.dart';

class SystemRepository {
  Future<dynamic> fetchSettings({required String type}) async {
    try {
      final result = await Api.get(
        queryParameters: {"type": type},
        url: Api.settings,
        useAuthToken: true,
      );

      return result['data'];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ApiException(e.toString());
    }
  }

  Future<List<Holiday>> fetchHolidays() async {
    try {
      final result = await Api.get(url: Api.holidays, useAuthToken: false);
      return ((result['data'] ?? []) as List)
          .map((holiday) => Holiday.fromJson(Map.from(holiday)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
