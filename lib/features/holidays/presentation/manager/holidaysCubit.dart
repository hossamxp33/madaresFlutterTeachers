
<<<<<<< HEAD
import 'package:eschool_teacher/core/repositories/systemInfoRepository.dart';
import 'package:eschool_teacher/features/holidays/data/models/holiday.dart';
=======
import 'package:madares_app_teacher/core/repositories/systemInfoRepository.dart';
import 'package:madares_app_teacher/features/holidays/data/models/holiday.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HolidaysState {}

class HolidaysInitial extends HolidaysState {}

class HolidaysFetchInProgress extends HolidaysState {}

class HolidaysFetchSuccess extends HolidaysState {
  final List<Holiday> holidays;

  HolidaysFetchSuccess({required this.holidays});
}

class HolidaysFetchFailure extends HolidaysState {
  final String errorMessage;

  HolidaysFetchFailure(this.errorMessage);
}

class HolidaysCubit extends Cubit<HolidaysState> {
  final SystemRepository _systemRepository;

  HolidaysCubit(this._systemRepository) : super(HolidaysInitial());

  Future<void> fetchHolidays() async {
    emit(HolidaysFetchInProgress());
    try {
      emit(HolidaysFetchSuccess(
          holidays: await _systemRepository.fetchHolidays(),),);
    } catch (e) {
      emit(HolidaysFetchFailure(e.toString()));
    }
  }

  List<Holiday> holidays() {
    if (state is HolidaysFetchSuccess) {
      return (state as HolidaysFetchSuccess).holidays;
    }
    return [];
  }
}
