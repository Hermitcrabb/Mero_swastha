import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ExerciseTrackerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logExercise(String userId) async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final logRef = _firestore.collection('users').doc(userId).collection('exercise_log').doc(today);

    // If already logged today, skip
    final existingLog = await logRef.get();
    if (existingLog.exists) return;

    // Save today's log
    await logRef.set({
      'completed': true,
      'timestamp': now.toIso8601String(),
    });

    // Update streak
    final streakRef = _firestore.collection('users').doc(userId).collection('metadata').doc('streak');
    final streakDoc = await streakRef.get();

    int newStreak = 1;
    String todayStr = DateFormat('yyyy-MM-dd').format(now);
    String yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    if (streakDoc.exists) {
      final lastCompleted = streakDoc['lastCompletedDate'];

      if (lastCompleted == yesterdayStr) {
        newStreak = streakDoc['currentStreak'] + 1;
      }
    }

    await streakRef.set({
      'currentStreak': newStreak,
      'lastCompletedDate': todayStr,
    });
  }

  Future<List<DateTime>> getExerciseDates(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('exercise_log')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final timestamp = doc['timestamp'] as String;
      return DateTime.parse(timestamp);
    }).toList();
  }

  Future<int> getCurrentStreak(String userId) async {
    final streakDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('metadata')
        .doc('streak')
        .get();

    return streakDoc.exists ? streakDoc['currentStreak'] : 0;
  }
}
