/*import 'package:bloc/bloc.dart';
import 'package:my_be_real/bloc/user/user_event.dart';
import 'package:my_be_real/bloc/user/user_statedel.dart';
import 'package:my_be_real/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
     on<GetUserRequested>((event, emit) async {
      emit(UserLoading());
      try {
        User? user = await userRepository.getUser();
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(UserError("Error al cargar el usuario."));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUserRequested>((event, emit) async {
      emit(UserLoading());
      try {
        User? user = await userRepository.updateUser(event.user);
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(UserError("Error al actualizar el usuario."));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
*/
