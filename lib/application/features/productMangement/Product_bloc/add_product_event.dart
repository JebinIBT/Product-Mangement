part of 'add_product_bloc.dart';

@immutable
sealed class AddProductEvent {}

class AddProduct extends AddProductEvent {
  final Product product;

  AddProduct(this.product);
}