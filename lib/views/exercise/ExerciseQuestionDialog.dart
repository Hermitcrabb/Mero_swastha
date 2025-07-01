import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExerciseQuestionDialog extends StatefulWidget {
  final String uid;
  final Map<String, dynamic>? initialData;

  const ExerciseQuestionDialog({
    Key? key,
    required this.uid,
    this.initialData,
  }) : super(key: key);

  @override
  State<ExerciseQuestionDialog> createState() => _ExerciseQuestionDialogState();
}

class _ExerciseQuestionDialogState extends State<ExerciseQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  late String _goal;
  late String _experience;
  late String _workoutLocation;
  late List<String> _selectedEquipment;
  late int _workoutDaysPerWeek;

  final List<String> _equipmentOptions = [
    'Dumbbells',
    'Resistance Bands',
    'Yoga Mat',
    'Pull-up Bar',
    'Barbell',
    'Weight Plates',
    'Kettlebells',
    'Medicine Ball'
  ];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _goal = widget.initialData?['goal'] ?? 'muscle_gain';
    _experience = widget.initialData?['experience'] ?? 'beginner';
    _workoutLocation = widget.initialData?['workoutLocation'] ?? 'home';
    _selectedEquipment = List<String>.from(widget.initialData?['equipment'] ?? []);
    _workoutDaysPerWeek = widget.initialData?['workoutDaysPerWeek'] ?? 3;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      await _firestore.collection('users').doc(widget.uid).update({
        'exerciseProfile': _buildExerciseProfile(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop(_buildExerciseProfile());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save exercise info",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Map<String, dynamic> _buildExerciseProfile() {
    return {
      'goal': _goal,
      'experience': _experience,
      'workoutLocation': _workoutLocation,
      'equipment': _selectedEquipment,
      'workoutDaysPerWeek': _workoutDaysPerWeek,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildGoalDropdown(),
                const SizedBox(height: 16),
                _buildExperienceDropdown(),
                const SizedBox(height: 16),
                _buildLocationDropdown(),
                const SizedBox(height: 16),
                _buildEquipmentChips(),
                const SizedBox(height: 16),
                _buildDaysInput(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Customize Your Workout Plan",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll create a personalized plan based on your answers",
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoalDropdown() {
    return DropdownButtonFormField<String>(
      value: _goal,
      items: const [
        DropdownMenuItem(value: 'muscle_gain', child: Text('Build Muscle')),
        DropdownMenuItem(value: 'weight_loss', child: Text('Lose Weight')),
        DropdownMenuItem(value: 'maintenance', child: Text('Stay Fit')),
      ],
      onChanged: (val) => setState(() => _goal = val!),
      decoration: const InputDecoration(
        labelText: "Primary Goal",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildExperienceDropdown() {
    return DropdownButtonFormField<String>(
      value: _experience,
      items: const [
        DropdownMenuItem(value: 'beginner', child: Text('Beginner (0-6 months)')),
        DropdownMenuItem(value: 'intermediate', child: Text('Intermediate (6+ months)')),
        DropdownMenuItem(value: 'advanced', child: Text('Advanced (2+ years)')),
      ],
      onChanged: (val) => setState(() => _experience = val!),
      decoration: const InputDecoration(
        labelText: "Experience Level",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: _workoutLocation,
      items: const [
        DropdownMenuItem(value: 'home', child: Text('Home (Limited Equipment)')),
        DropdownMenuItem(value: 'gym', child: Text('Gym (Full Equipment)')),
        DropdownMenuItem(value: 'outdoor', child: Text('Outdoor/Public Spaces')),
      ],
      onChanged: (val) => setState(() => _workoutLocation = val!),
      decoration: const InputDecoration(
        labelText: "Workout Location",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildEquipmentChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Equipment",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _equipmentOptions.map((eq) {
            return FilterChip(
              label: Text(eq),
              selected: _selectedEquipment.contains(eq),
              onSelected: (selected) => _handleEquipmentSelection(eq, selected),
              selectedColor: const Color(0xFFEDE7F6), // Equivalent to Colors.deepPurple.withOpacity(0.2)
              checkmarkColor: Colors.deepPurple,
              labelStyle: TextStyle(
                color: _selectedEquipment.contains(eq)
                    ? Colors.deepPurple
                    : Colors.grey[800],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _handleEquipmentSelection(String equipment, bool selected) {
    setState(() {
      if (selected) {
        _selectedEquipment.add(equipment);
      } else {
        _selectedEquipment.remove(equipment);
      }
    });
  }

  Widget _buildDaysInput() {
    return TextFormField(
      initialValue: _workoutDaysPerWeek.toString(),
      decoration: const InputDecoration(
        labelText: "Workout Days Per Week",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: TextInputType.number,
      validator: _validateDaysInput,
      onSaved: _saveDaysInput,
    );
  }

  String? _validateDaysInput(String? value) {
    final number = int.tryParse(value ?? '');
    if (number == null || number < 1 || number > 7) {
      return 'Please enter between 1-7 days';
    }
    return null;
  }

  void _saveDaysInput(String? value) {
    _workoutDaysPerWeek = int.tryParse(value ?? '') ?? 3;
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isSaving
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text(
        "Generate My Workout Plan",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}