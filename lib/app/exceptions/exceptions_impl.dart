import 'base_exception.dart';

class BadRequest implements IBaseException {
  final String _message;
  BadRequest({String? message}) : _message = message ?? 'Erro na requisição';

  @override
  int get statusCode => 400;

  @override
  String get message => _message;
}

// class AuthException implements IBaseException {
//   @override
//   int get statusCode => 401;

//   @override
//   String get message => 'Email ou senha incorretos';
// }

// class SignedInException implements IBaseException {
//   @override
//   int get statusCode => 401;

//   @override
//   String get message => 'Usuário já conectado';
// }

class UnauthorizedException implements IBaseException {
  final String _message;
  UnauthorizedException({String? message})
      : _message = message ?? 'Não autorizado';

  @override
  int get statusCode => 401;

  @override
  String get message => _message;
}

class NotFoundException implements IBaseException {
  final String _message;
  NotFoundException({String? message})
      : _message = message ?? 'Recurso não encontrado';

  @override
  int get statusCode => 404;

  @override
  String get message => _message;
}

class SessionExpiredException implements IBaseException {
  final String _message;
  SessionExpiredException({String? message})
      : _message = message ?? 'Sessão expirada';

  @override
  int get statusCode => 440;

  @override
  String get message => _message;
}

class ForbiddenResourceException implements IBaseException {
  final String _message;
  ForbiddenResourceException({String? message})
      : _message = message ?? 'Acesso indisponível';

  @override
  int get statusCode => 403;

  @override
  String get message => _message;
}

class UnprocessableEntityException implements IBaseException {
  final String _message;
  UnprocessableEntityException({String? message})
      : _message = message ?? 'Recurso não foi processado';

  @override
  int get statusCode => 422;

  @override
  String get message => _message;
}

class InternalServerException implements IBaseException {
  final String _message;
  InternalServerException({String? message})
      : _message = message ?? 'Erro interno no servidor';
  @override
  int get statusCode => 500;

  @override
  String get message => _message;
}

// class ConnectionServerException implements IBaseException {
//   @override
//   int get statusCode => 500;

//   @override
//   String get message => 'Erro de conexão com o servidor';
// }

// class ServiceUnavailableServerException implements IBaseException {
//   @override
//   int get statusCode => 503;

//   @override
//   String get message => 'Serviço indisponível';
// }
