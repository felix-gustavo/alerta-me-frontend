import 'package:form_validator/form_validator.dart';

extension ValidationBuilderExtension on ValidationBuilder {
  ValidationBuilder minLengthCustom(int minLength) => add((value) {
        if ((value?.trim() ?? '').length < minLength) {
          return 'O campo deve ter pelo menos $minLength caracteres';
        }
        return null;
      });
}
