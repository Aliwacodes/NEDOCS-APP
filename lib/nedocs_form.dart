import 'package:flutter/material.dart';

class NEDOCSForm extends StatefulWidget {
  @override
  _NEDOCSFormState createState() => _NEDOCSFormState();
}

class _NEDOCSFormState extends State<NEDOCSForm> {
  final _formKey = GlobalKey<FormState>();
  final _totalBedsController = TextEditingController();
  final _occupiedBedsController = TextEditingController();
  final _admitsController = TextEditingController();
  final _waitingController = TextEditingController();
  final _longestAdmitTimeController = TextEditingController();
  final _respiratorsController = TextEditingController();
  double? _nedocsScore;
  String? _nedocsInterpretation;

  void _calculateNEDOCS() {
    if (_formKey.currentState?.validate() ?? false) {
      final totalBeds = int.parse(_totalBedsController.text);
      final occupiedBeds = int.parse(_occupiedBedsController.text);
      final admits = int.parse(_admitsController.text);
      final waiting = int.parse(_waitingController.text);
      final longestAdmitTime = double.parse(_longestAdmitTimeController.text);
      final respirators = int.parse(_respiratorsController.text);

      final calculator = NEDOCSCalculator();
      setState(() {
        _nedocsScore = calculator.calculateNEDOCS(totalBeds, occupiedBeds,
            admits, waiting, longestAdmitTime, respirators);
        _nedocsInterpretation = _interpretNEDOCSScore(_nedocsScore!);
      });
    }
  }

  String _interpretNEDOCSScore(double score) {
    if (score <= 20) {
      return 'Not busy';
    } else if (score <= 60) {
      return 'Busy';
    } else if (score <= 100) {
      return 'Extremely busy but not overcrowded';
    } else if (score <= 140) {
      return 'Over-crowded';
    } else if (score <= 180) {
      return 'Severely over-crowded';
    } else {
      return 'Dangerously over-crowded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildTextFormField(
              controller: _totalBedsController,
              label: 'Total ED Beds',
              icon: Icons.bed,
            ),
            SizedBox(height: 16.0),
            _buildTextFormField(
              controller: _occupiedBedsController,
              label: 'Occupied ED Beds',
              icon: Icons.bedroom_child,
            ),
            SizedBox(height: 16.0),
            _buildTextFormField(
              controller: _admitsController,
              label: 'Admits',
              icon: Icons.person_add,
            ),
            SizedBox(height: 16.0),
            _buildTextFormField(
              controller: _waitingController,
              label: 'Waiting',
              icon: Icons.access_time,
            ),
            SizedBox(height: 16.0),
            _buildTextFormField(
              controller: _longestAdmitTimeController,
              label: 'Longest Admit Time (hours)',
              icon: Icons.timer,
            ),
            SizedBox(height: 16.0),
            _buildTextFormField(
              controller: _respiratorsController,
              label: 'Respirators in Use',
              icon: Icons.medical_services,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculateNEDOCS,
              child: Text('Calculate NEDOCS'),
            ),
            SizedBox(height: 16.0),
            if (_nedocsScore != null)
              Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'NEDOCS Score: ${_nedocsScore!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Interpretation: $_nedocsInterpretation',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a number';
        }
        return null;
      },
    );
  }
}

class NEDOCSCalculator {
  double calculateNEDOCS(int totalBeds, int occupiedBeds, int admits,
      int waiting, double longestAdmitTime, int respirators) {
    return 85.8 * (occupiedBeds / totalBeds) +
        600 * (admits / totalBeds) +
        5.64 * waiting +
        0.93 * longestAdmitTime +
        13.4 * (respirators / totalBeds) -
        20;
  }
}
