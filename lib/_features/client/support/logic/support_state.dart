import 'package:equatable/equatable.dart';
import '../data/models/contact_info_model.dart';
import '../data/models/faq_model.dart';

enum SupportLoadingStatus { initial, loading, success, error }
enum SendMessageStatus { initial, loading, success, error }

class SupportState extends Equatable {
  final SupportLoadingStatus faqsStatus;
  final SupportLoadingStatus policyStatus;
  final SupportLoadingStatus aboutStatus;
  final SupportLoadingStatus contactInfoStatus;
  final SendMessageStatus sendMessageStatus;
  final List<FaqModel> faqs;
  final String policy;
  final String about;
  final ContactInfoModel contactInfo;
  final String errorMessage;
  final String successMessage;

  const SupportState({
    this.faqsStatus = SupportLoadingStatus.initial,
    this.policyStatus = SupportLoadingStatus.initial,
    this.aboutStatus = SupportLoadingStatus.initial,
    this.contactInfoStatus = SupportLoadingStatus.initial,
    this.sendMessageStatus = SendMessageStatus.initial,
    this.faqs = const [],
    this.policy = '',
    this.about = '',
    this.contactInfo = const ContactInfoModel(),
    this.errorMessage = '',
    this.successMessage = '',
  });

  bool get isFaqsLoading => faqsStatus == SupportLoadingStatus.loading;
  bool get isPolicyLoading => policyStatus == SupportLoadingStatus.loading;
  bool get isAboutLoading => aboutStatus == SupportLoadingStatus.loading;
  bool get isContactInfoLoading => contactInfoStatus == SupportLoadingStatus.loading;
  bool get isSendingMessage => sendMessageStatus == SendMessageStatus.loading;

  SupportState copyWith({
    SupportLoadingStatus? faqsStatus,
    SupportLoadingStatus? policyStatus,
    SupportLoadingStatus? aboutStatus,
    SupportLoadingStatus? contactInfoStatus,
    SendMessageStatus? sendMessageStatus,
    List<FaqModel>? faqs,
    String? policy,
    String? about,
    ContactInfoModel? contactInfo,
    String? errorMessage,
    String? successMessage,
  }) {
    return SupportState(
      faqsStatus: faqsStatus ?? this.faqsStatus,
      policyStatus: policyStatus ?? this.policyStatus,
      aboutStatus: aboutStatus ?? this.aboutStatus,
      contactInfoStatus: contactInfoStatus ?? this.contactInfoStatus,
      sendMessageStatus: sendMessageStatus ?? this.sendMessageStatus,
      faqs: faqs ?? this.faqs,
      policy: policy ?? this.policy,
      about: about ?? this.about,
      contactInfo: contactInfo ?? this.contactInfo,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        faqsStatus,
        policyStatus,
        aboutStatus,
        contactInfoStatus,
        sendMessageStatus,
        faqs,
        policy,
        about,
        contactInfo,
        errorMessage,
        successMessage,
      ];
}

