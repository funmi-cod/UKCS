import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukcs_app/features/home/presentation/state/home_state.dart';
import 'package:ukcs_app/features/home/presentation/viewmodel/home_view_model.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);
