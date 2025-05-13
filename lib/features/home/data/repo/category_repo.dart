import 'package:angelina_app/core/utils/constants/constants.dart';
import 'package:angelina_app/features/home/data/model/category_model.dart';
import 'package:dio/dio.dart';

class CategoryRepo {
  final Dio _dio = Dio();

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get(AppConstants.categoryBaseUrl);
      return (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'حدث خطأ غير متوقع أثناء تحميل الفئات: $e';
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'انتهت مهلة الاتصال أثناء تحميل الفئات.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاستلام أثناء تحميل الفئات.';
    } else if (e.type == DioExceptionType.badResponse) {
      return 'خطأ في الخادم أثناء تحميل الفئات: ${e.response?.statusCode}';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'لا يوجد اتصال بالإنترنت أثناء تحميل الفئات.';
    } else {
      return 'حدث خطأ غير متوقع}';
    }
  }
}
