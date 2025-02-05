import '../../domain/geometry_shapes/geometry_shapes_entity.dart';

class ShapeRepository {
  List<Shape> getShapes() {
    return [
      Shape(name: 'Circle', imagePath: 'assets/geometric_shapes/circle.png'),
      Shape(name: 'Diamond', imagePath: 'assets/geometric_shapes/diamond.png'),
      Shape(name: 'Hexagon', imagePath: 'assets/geometric_shapes/Hexagon.png'),
      Shape(name: 'Left Triangle', imagePath: 'assets/geometric_shapes/left__triangle.png'),
      Shape(name: 'Octagon', imagePath: 'assets/geometric_shapes/octagon.png'),
      Shape(name: 'Oval', imagePath: 'assets/geometric_shapes/oval.png'),
      Shape(name: 'Pentagon', imagePath: 'assets/geometric_shapes/pentagon.png'),
      Shape(name: 'Rectangle', imagePath: 'assets/geometric_shapes/rectangle.png'),
      Shape(name: 'Right Triangle', imagePath: 'assets/geometric_shapes/right_triangle.png'),
      Shape(name: 'Semicircle', imagePath: 'assets/geometric_shapes/semicircle.png'),
      Shape(name: 'Square', imagePath: 'assets/geometric_shapes/square.png'),
      Shape(name: 'Star', imagePath: 'assets/geometric_shapes/star.png'),
      Shape(name: 'Triangle', imagePath: 'assets/geometric_shapes/triangle.png'),
    ];
  }
}