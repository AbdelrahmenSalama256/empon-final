import 'package:bloc/bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {

  ProductCubit(): super(ProductInitial());



}
