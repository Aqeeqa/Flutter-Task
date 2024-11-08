import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/human.dart';
import '../Services/api_service.dart';

class HumanCubit extends Cubit<HumanState> {
  final ApiService apiService;

  HumanCubit(this.apiService) : super(HumanInitial());

  Future<void> fetchHumans() async {
    emit(HumanLoading());
    try {
      final humans = await apiService.getHumans();
      emit(HumanLoaded(humans));
    } catch (e) {
      emit(HumanError("An error occurred"));
    }
  }

  Future<void> fetchHumanDetail(int id) async {
    emit(HumanLoading());
    try {
      final human = await apiService.getHumanDetail(id);
      emit(HumanDetailLoaded(human));
    } catch (e) {
      emit(HumanError("An error occurred"));
    }
  }
}

abstract class HumanState {}

class HumanInitial extends HumanState {}

class HumanLoading extends HumanState {}

class HumanLoaded extends HumanState {
  final List<Human> humans;

  HumanLoaded(this.humans);
}

class HumanDetailLoaded extends HumanState {
  final Human human;

  HumanDetailLoaded(this.human);
}

class HumanError extends HumanState {
  final String message;

  HumanError(this.message);
}
