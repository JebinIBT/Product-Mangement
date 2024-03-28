import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machinetest/application/features/productMangement/models/product_model.dart';
import 'package:meta/meta.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  AddProductBloc() : super(AddProductInitial()) {
    on<AddProduct>((event, emit) async {
      emit(AddProductLoading());
      try {
        await products.doc(event.product.id).set({
          'id': event.product.id,
          'name': event.product.name,
          'description': event.product.description,
          'quantity': event.product.quantity,
          'price': event.product.price,
        });
      } catch (e) {
        emit(AddProductFailure(e.toString()));
      }
    });
  }
}

