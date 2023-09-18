import 'custom_validator.dart';

class EmailValidator implements CustomValidator {
  @override
  String? validator(String? value) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);

    if (value!.isEmpty) return 'Por favor, forneça um e-mail';
    if (value.isNotEmpty && !regex.hasMatch(value)) return 'Email inválido';

    return null;
  }
}
