import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';

/// Contrato de DataSource remota para histórias
abstract class RemoteStoryDataSource {
  Future<List<Map<String, dynamic>>> fetchStories();
  Future<Map<String, dynamic>> fetchStoryById(String id);
  Future<List<Map<String, dynamic>>> searchStories(String query);
}

/// Implementação com Dio para consum ir APIs externas
class RemoteStoryDataSourceImpl implements RemoteStoryDataSource {
  final Dio dio;

  RemoteStoryDataSourceImpl({required this.dio}) {
    // Configurar interceptors padrão
    dio.options = BaseOptions(
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
      contentType: Headers.jsonContentType,
    );

    // Logger interceptor para debug
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('Dio Log: $obj'),
      ),
    );

    // Retry interceptor
    dio.interceptors.add(
      RetryInterceptor(maxRetries: AppConstants.maxRetries),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchStories() async {
    try {
      // Exemplo: Chamar uma API fictícia
      // Substitua pela URL real da sua API
      const String endpoint = '/stories';

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['stories'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Erro ao buscar histórias: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchStoryById(String id) async {
    try {
      final String endpoint = '/stories/$id';
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('História não encontrada');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar história: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchStories(String query) async {
    try {
      final response = await dio.get(
        '/stories/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro na busca de histórias');
      }
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    }
  }
}

/// Exemplo de uso como Provider no Riverpod:
/// 
/// ```dart
/// final dioProvider = Provider((ref) {
///   return Dio()
///     ..options.baseUrl = 'https://api.example.com'; // URL base
/// });
/// 
/// final remoteStoryDataSourceProvider = Provider((ref) {
///   final dio = ref.watch(dioProvider);
///   return RemoteStoryDataSourceImpl(dio: dio);
/// });
/// 
/// // Para usar em um use case:
/// final storiesProvider = FutureProvider((ref) async {
///   final dataSource = ref.watch(remoteStoryDataSourceProvider);
///   final stories = await dataSource.fetchStories();
///   return stories;
/// });
/// ```

/// Exemplo de estrutura JSON esperada da API:
/// 
/// ```json
/// {
///   "stories": [
///     {
///       "id": "story_1",
///       "title": "Cinderela",
///       "description": "Uma história mágica",
///       "content": "Era uma vez...",
///       "author": "Hans Christian Andersen",
///       "coverImageUrl": "https://...",
///       "ageMin": 3,
///       "ageMax": 8,
///       "duration": 300,
///       "rating": 4.5,
///       "readCount": 1250,
///       "createdAt": "2024-01-15T10:30:00Z",
///       "isFavorite": false
///     }
///   ]
/// }
/// ```
