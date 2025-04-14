import 'package:objectbox/objectbox.dart';
@Entity()

class Person {
  int id;
  final String name;

  Person({this.id = 0, this.name = 'no name'});
}