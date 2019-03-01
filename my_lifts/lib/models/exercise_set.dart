class ExerciseSet {
  int exerciseId;
  int reps;
  int weight;
  String timestamp;
  int id;
  String dateCompleted;

  ExerciseSet({ this.exerciseId, this.reps, this.weight, this.timestamp, this.dateCompleted });

  ExerciseSet.fromMap(Map<String, dynamic> properties) {
    id =properties['id'];
    timestamp =properties['timestamp'];
    weight =properties['weight'];
    reps =properties['reps'];
    exerciseId =properties['exercise_id'];
    dateCompleted =properties['date_completed'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp':timestamp,
      'weight':weight,
      'reps':reps,
      'exercise_id':exerciseId,
      'date_completed':dateCompleted
    };
  }
}