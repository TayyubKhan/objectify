import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/application/drawing/drawing_state.dart';

import '../../data/drawing/drawingNotifier.dart';

final drawingStateProvider = StateNotifierProvider<DrawingController, DrawingState>(
      (ref) => DrawingController(),
);
