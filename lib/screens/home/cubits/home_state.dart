part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoriesLoaded extends HomeState {
  final List<Categories> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesError extends HomeState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object> get props => [message];
}