import 'package:embone/features/client/auth/view/pages/cubit/guest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestCubit extends Cubit<GuestState> {
  GuestCubit() : super(GuestInitial());
  
}
 