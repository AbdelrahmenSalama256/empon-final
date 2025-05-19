import 'package:bloc/bloc.dart';
import 'package:embone/features/client/cart/data/model/cart_model.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_state.dart';


class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  CartCubit(this.cartRepo) : super(CartInitial());

  List<CartItemModel> cartItems = [];

  Future<void> fetchCart() async {
    emit(CartLoading());
    final result = await cartRepo.fetchCart();
    result.fold(
      (error) => emit(CartError(error)),
      (cartResponse) {
        cartItems = cartResponse.data;
        emit(CartLoaded(cartResponse));
      },
    );
  }

  Future<void> addProductToCart({
    required int productId,
    required int variationId,
  }) async {
    emit(CartLoading());
    final result = await cartRepo.addProductToCart(
      productId: productId,
      variationId: variationId,
    );
    result.fold(
      (error) => emit(CartError(error)),
      (addToCartResponse) {
        if (addToCartResponse.success) {
          cartItems.add(addToCartResponse.data);
          emit(AddToCartSuccess(addToCartResponse.message));
          fetchCart();
        } else {
          emit(CartError(addToCartResponse.message));
        }
      },
    );
  }

  Future<void> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    emit(CartLoading());
    final result = await cartRepo.updateCartItemQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    result.fold(
      (error) => emit(CartError(error)),
      (message) {
        final index = cartItems.indexWhere((item) => item.id == cartItemId);
        if (index != -1) {
          cartItems[index] = CartItemModel(
            id: cartItems[index].id,
            productId: cartItems[index].productId,
            name: cartItems[index].name,
            image: cartItems[index].image,
            quantity: quantity,
            price: cartItems[index].price,
            attributes: cartItems[index].attributes,
            color: cartItems[index].color,
          );
        }
        emit(CartUpdated(message));
        fetchCart(); // Refresh cart after updating
      },
    );
  }

  Future<void> removeCartItem(int cartItemId) async {
    emit(CartLoading());
    final result = await cartRepo.removeCartItem(cartItemId);
    result.fold(
      (error) => emit(CartError(error)),
      (message) {
        cartItems.removeWhere((item) => item.id == cartItemId);
        emit(CartItemRemoved(message));
        fetchCart();
      },
    );
  }
}
