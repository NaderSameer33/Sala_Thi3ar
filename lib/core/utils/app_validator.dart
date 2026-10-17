abstract class AppValidator {
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? 'برجاء إدخال $fieldName' : 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال رقم الجوال';
    }
    final cleanValue = value.trim().replaceAll(' ', '');
    final saudiPhoneRegex = RegExp(r'^(05|5)[0-9]{8}$');
    if (!saudiPhoneRegex.hasMatch(cleanValue)) {
      return 'برجاء إدخال رقم جوال سعودي صحيح (مثال: 05xxxxxxxx)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'برجاء إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن لا تقل عن 6 أحرف أو أرقام';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'برجاء تأكيد كلمة المرور';
    }
    if (value != originalPassword) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  static String? validateEmail(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'برجاء إدخال البريد الإلكتروني' : null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'برجاء إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال رمز التحقق';
    }
    if (value.trim().length != 4) {
      return 'رمز التحقق يتكون من 4 أرقام';
    }
    return null;
  }

  static String? validateIban(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال رقم الآيبان';
    }
    final cleanValue = value.trim().replaceAll(' ', '').toUpperCase();
    if (!cleanValue.startsWith('SA') || cleanValue.length != 24) {
      return 'رقم الآيبان السعودي يجب أن يبدأ بـ SA ويتكون من 24 حرف ورقم';
    }
    return null;
  }

  static String? validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال رقم الهوية / الإقامة';
    }
    final cleanValue = value.trim();
    if (!RegExp(r'^[12][0-9]{9}$').hasMatch(cleanValue)) {
      return 'رقم الهوية الوطنية أو الإقامة يجب أن يتكون من 10 أرقام';
    }
    return null;
  }
}
