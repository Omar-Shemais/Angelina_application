import 'package:angelina_app/features/home/data/repo/category_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo categoryRepo;

  CategoryCubit(this.categoryRepo) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await categoryRepo.fetchCategories();
      emit(CategorySuccess(categories));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
