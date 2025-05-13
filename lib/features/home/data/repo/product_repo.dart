import 'package:angelina_app/core/utils/constants/constants.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio _dio = Dio();

  Future<List<ProductModel>> fetchProducts({
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.prouductsBaseUrl,
        queryParameters: {
          'consumer_key': AppConstants.consumerKey,
          'consumer_secret': AppConstants.consumerSecret,
          'page': page,
          'per_page': perPage,
        },
      );
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e, 'تحميل المنتجات');
    } catch (e) {
      throw 'خطأ غير متوقع أثناء تحميل المنتجات: $e';
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory({
    required int categoryId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.prouductsBaseUrl,
        queryParameters: {
          'consumer_key': AppConstants.consumerKey,
          'consumer_secret': AppConstants.consumerSecret,
          'page': page,
          'per_page': perPage,
          'category': categoryId,
        },
      );
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e, 'تحميل منتجات الفئة');
    } catch (e) {
      throw 'خطأ غير متوقع أثناء تحميل منتجات الفئة: $e';
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        AppConstants.prouductsBaseUrl,
        queryParameters: {
          'consumer_key': AppConstants.consumerKey,
          'consumer_secret': AppConstants.consumerSecret,
          'search': query,
          'per_page': 50,
        },
      );
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e, 'البحث عن المنتجات');
    } catch (e) {
      throw 'خطأ غير متوقع أثناء البحث عن المنتجات: $e';
    }
  }

  Future<ProductModel> fetchProductById(int id) async {
    try {
      final response = await _dio.get(
        '${AppConstants.prouductsBaseUrl}/$id',
        queryParameters: {
          'consumer_key': AppConstants.consumerKey,
          'consumer_secret': AppConstants.consumerSecret,
        },
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, 'تحميل المنتج بالمعرّف $id');
    } catch (e) {
      throw 'خطأ غير متوقع أثناء تحميل المنتج بالمعرّف $id: $e';
    }
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await _dio.get(AppConstants.baseUrl);
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e, 'تحميل جميع المنتجات');
    } catch (e) {
      throw 'خطأ غير متوقع أثناء تحميل جميع المنتجات: $e';
    }
  }

  String _handleDioError(DioException e, String context) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'انتهت مهلة الاتصال أثناء $context.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاستلام أثناء $context.';
    } else if (e.type == DioExceptionType.badResponse) {
      return 'خطأ في الخادم أثناء $context: ${e.response?.statusCode}';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'لا يوجد اتصال بالإنترنت أثناء $context.';
    } else {
      return 'حدث خطأ غير متوقع أثناء ';
    }
  }
}

// class ProductRepository {
//   final Dio _dio = Dio();

//   Future<List<ProductModel>> fetchProducts() async {
//     try {
//       final response = await _dio.get(
//         'https://angelinashop2025.com/wp-json/wc/v3/products?per_page=100&consumer_key=ck_0e46d6f95c508e91ae3d99f64845cc3b6f5eb5e5&consumer_secret=cs_ab95108f084683daa92f347a81c6d7a5035435ac',
//       );
//       List<ProductModel> products =
//           (response.data as List)
//               .map((json) => ProductModel.fromJson(json))
//               .toList();

//       return products;
//     } catch (e) {
//       throw Exception('Failed to load products');
//     }
//   }
// }
