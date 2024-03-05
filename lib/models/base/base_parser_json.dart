import 'package:growtopia/models/api/code_response.dart';
import 'package:growtopia/models/api/login_response.dart';
import 'package:growtopia/models/api/request_email_response.dart';

mixin GPParserJson {
  static Map<Type, Function> _mapFactories<T>() {
    return <Type, Function>{
      T: (Map<String, dynamic> x) => _mapFactoryValue<T>(x),
    };
  }

  static dynamic _mapFactoryValue<T>(Map<String, dynamic> x) {
    // parse all items here
    switch (T) {
      case RequestEmailResponse:
        return RequestEmailResponse.fromJson(x);
      case LoginResponse:
        return LoginResponse.fromJson(x);
      case String:
        return x as String;
      case CodeResponse:
        return CodeResponse.fromJson(x);
      default:
        throw Exception("ApiResponseExtension _mapFactoryValue error!!!");
    }
  }

  static T parseJson<T>(Map<String, dynamic> x) {
    Map<Type, Function> factories = _mapFactories<T>();
    return factories[T]?.call(x);
  }
}
