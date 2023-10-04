import 'package:bloc/bloc.dart';
import 'package:my_be_real/bloc/user/user_event.dart';
import 'package:my_be_real/bloc/user/user_state.dart';
import 'package:my_be_real/models/user_model.dart';
import 'package:my_be_real/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<GetUserRequested>((event, emit) async {
      emit(UserLoading());
      try {
        User? user = await userRepository.getUserByEmail(event.email);
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(UserError("Error al cargar el usuario.",
              errorMessage:
                  "Contacta con un administrador si crees que es un error."));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
