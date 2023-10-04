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
        List<User?> users = await userRepository.getUserByEmail(event.email);
        print(users[1]);
        if (!users.contains(null)) {
          emit(UserLoaded(users[0]!, users[1]!));
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
