String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email wajib diisi';
  if (!value.contains('@') || !value.contains('.')) return 'Format email salah';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password wajib diisi';
  if (value.length < 6) return 'Minimal 6 karakter';
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) return 'Username wajib diisi';
  if (value.length < 3) return 'Minimal 3 karakter';
  return null;
}
