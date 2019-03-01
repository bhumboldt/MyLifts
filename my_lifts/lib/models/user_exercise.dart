
class UserExercise {
  int id;
  int exerciseId;

  UserExercise(this.exerciseId);

  UserExercise.fromMap(Map<String, dynamic> properties) {
    id =properties['id'];
    exerciseId =properties['exercise_id'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'exercise_id':exerciseId
    };
  }
}