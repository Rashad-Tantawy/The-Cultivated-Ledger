class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Value'}) {
    if (value == null || value.isEmpty) return '$field is required';
    final num = double.tryParse(value);
    if (num == null || num <= 0) return '$field must be a positive number';
    return null;
  }

  static String? shareCount(String? value, {required int available}) {
    if (value == null || value.isEmpty) return 'Enter number of shares';
    final count = int.tryParse(value);
    if (count == null || count <= 0) return 'Must be at least 1 share';
    if (count > available) return 'Only $available shares available';
    return null;
  }
}
