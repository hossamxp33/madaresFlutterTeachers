<<<<<<< HEAD
import 'package:eschool_teacher/features/announcements/data/repositories/announcementRepository.dart';
=======
import 'package:madares_app_teacher/features/announcements/data/repositories/announcementRepository.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteAnnouncementState {}

class DeleteAnnouncementInitial extends DeleteAnnouncementState {}

class DeleteAnnouncementInProgress extends DeleteAnnouncementState {}

class DeleteAnnouncementSuccess extends DeleteAnnouncementState {}

class DeleteAnnouncementFailure extends DeleteAnnouncementState {
  final String errorMessage;

  DeleteAnnouncementFailure(this.errorMessage);
}

class DeleteAnnouncementCubit extends Cubit<DeleteAnnouncementState> {
  final AnnouncementRepository _announcementRepository;

  DeleteAnnouncementCubit(this._announcementRepository)
      : super(DeleteAnnouncementInitial());

  Future<void> deleteAnnouncement(int announcementId) async {
    emit(DeleteAnnouncementInProgress());
    try {
      await _announcementRepository.deleteAnnouncement(announcementId);
      emit(DeleteAnnouncementSuccess());
    } catch (e) {
      emit(DeleteAnnouncementFailure(state.toString()));
    }
  }
}
