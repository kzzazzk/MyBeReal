import 'package:get/get.dart';
import 'package:my_be_real/bloc/auth_bloc.dart';

class InitialDependencies extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthBloc());
  }
}
