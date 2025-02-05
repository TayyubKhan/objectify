import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/geometry_shapes/geometry_shapes_entity.dart';
import 'geometry_shapes_repository.dart';

final shapeRepositoryProvider = Provider((ref) => ShapeRepository());

final shapesProvider = Provider<List<Shape>>((ref) {
  final repository = ref.watch(shapeRepositoryProvider);
  return repository.getShapes();
});
