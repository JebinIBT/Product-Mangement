part of 'add_product_bloc.dart';

@immutable
sealed class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final String productId;

  AddProductSuccess(this.productId);
}

class AddProductFailure extends AddProductState {
  final String error;

  AddProductFailure(this.error);
}
