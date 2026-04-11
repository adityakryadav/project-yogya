import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EligibilityEngineScreen extends StatefulWidget {
  const EligibilityEngineScreen({super.key});

  @override
  State<EligibilityEngineScreen> createState() => _EligibilityEngineScreenState();
}

class _EligibilityEngineScreenState extends State<EligibilityEngineScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rule-Based Eligibility', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() => _currentStep += 1);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                }
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 2 ? 'Run Engine' : 'Next Phase'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const Text('Identity'),
                  isActive: _currentStep >= 0,
                  content: Column(
                    children: [
                      _buildCategorySelector(),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Academics'),
                  isActive: _currentStep >= 1,
                  content: Column(
                    children: [
                      TextFormField(
                        initialValue: '88.4%',
                        decoration: const InputDecoration(labelText: 'Verify 10th Aggregate', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: '85.2%',
                        decoration: const InputDecoration(labelText: 'Verify 12th Aggregate', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Graduation CGPA / %', border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Review'),
                  isActive: _currentStep >= 2,
                  content: const Text('Confirm your details. The precision logic engine will calculate your matches across all tracked examinations based on specific notification rules.'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Live Eligibility Pulse', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _buildPulseBar('SSC CGL', 0.92, AppColors.success, 'Eligible: Age and qualification match.'),
                const SizedBox(height: 12),
                _buildPulseBar('IBPS PO', 0.85, AppColors.warning, 'Partial: Graduation details pending.'),
                const SizedBox(height: 12),
                _buildPulseBar('AFCAT', 0.40, AppColors.error, 'Ineligible: Age limit exceeded.'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPill('General', true),
        _buildPill('OBC', false),
        _buildPill('SC', false),
        _buildPill('ST', false),
      ],
    );
  }

  Widget _buildPill(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.textSecondary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPulseBar(String exam, double match, Color color, String reason) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(exam, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${(match * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: match,
          backgroundColor: AppColors.pageBackground,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(reason, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
