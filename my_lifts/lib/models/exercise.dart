class Exercise {
  String name;
  String exerciseGroup;
  int id;

  Exercise({ this.name, this.exerciseGroup, this.id });

  Exercise.fromMap(Map<String, dynamic> properties) {
    name =properties['name'];
    exerciseGroup =properties['exercise_group'];
    id =properties['id'];
  }
}