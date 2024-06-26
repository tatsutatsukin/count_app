import 'package:objectbox/objectbox.dart';

@Entity()
class Member {
  Member({
    required this.name,
    required this.groupName,
    required this.count,
  });

  int id = 0;

  String name;
  String groupName;
  int count;
}
