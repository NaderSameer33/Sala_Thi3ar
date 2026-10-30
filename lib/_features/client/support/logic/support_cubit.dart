import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/send_contact_request_body.dart';
import '../data/repos/support_repo.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final SupportRepo _supportRepo;

  SupportCubit(this._supportRepo) : super(const SupportState());

  void resetSendMessageStatus() {
    emit(state.copyWith(
      sendMessageStatus: SendMessageStatus.initial,
      successMessage: '',
      errorMessage: '',
    ));
  }

  Future<void> getFaqs() async {
    emit(state.copyWith(faqsStatus: SupportLoadingStatus.loading));
    final result = await _supportRepo.getFaqs();
    result.fold(
      (failure) => emit(state.copyWith(
        faqsStatus: SupportLoadingStatus.error,
        errorMessage: failure.message,
      )),
      (faqs) => emit(state.copyWith(
        faqsStatus: SupportLoadingStatus.success,
        faqs: faqs,
      )),
    );
  }

  Future<void> getPolicy() async {
    emit(state.copyWith(policyStatus: SupportLoadingStatus.loading));
    final result = await _supportRepo.getPolicy();
    result.fold(
      (failure) => emit(state.copyWith(
        policyStatus: SupportLoadingStatus.error,
        errorMessage: failure.message,
      )),
      (policy) => emit(state.copyWith(
        policyStatus: SupportLoadingStatus.success,
        policy: policy,
      )),
    );
  }

  Future<void> getAbout() async {
    emit(state.copyWith(aboutStatus: SupportLoadingStatus.loading));
    final result = await _supportRepo.getAbout();
    result.fold(
      (failure) => emit(state.copyWith(
        aboutStatus: SupportLoadingStatus.error,
        errorMessage: failure.message,
      )),
      (about) => emit(state.copyWith(
        aboutStatus: SupportLoadingStatus.success,
        about: about,
      )),
    );
  }

  Future<void> getContactInfo() async {
    emit(state.copyWith(contactInfoStatus: SupportLoadingStatus.loading));
    final result = await _supportRepo.getContactInfo();
    result.fold(
      (failure) => emit(state.copyWith(
        contactInfoStatus: SupportLoadingStatus.error,
        errorMessage: failure.message,
      )),
      (info) => emit(state.copyWith(
        contactInfoStatus: SupportLoadingStatus.success,
        contactInfo: info,
      )),
    );
  }

  Future<bool> sendMessage(SendContactRequestBody body) async {
    emit(state.copyWith(sendMessageStatus: SendMessageStatus.loading));
    final result = await _supportRepo.sendContact(body);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          sendMessageStatus: SendMessageStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (message) {
        emit(state.copyWith(
          sendMessageStatus: SendMessageStatus.success,
          successMessage: message,
        ));
        return true;
      },
    );
  }
}

