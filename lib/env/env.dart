import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'geminiApiKey')
    static const String geminiApiKey = _Env.geminiApiKey;

    @EnviedField(varName: 'huggingfaceApiKey')
    static const String huggingfaceApiKey = _Env.huggingfaceApiKey;
}