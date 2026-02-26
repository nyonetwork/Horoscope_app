import 'package:flutter/material.dart';
import 'package:horoscope_app/data/compatibility_data.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  DateTime? _myDate;
  DateTime? _partnerDate;
  int? _score;
  String _mySign = '';
  String _partnerSign = '';
  bool _didInitFromProfile = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitFromProfile) return;

    final savedBirthdate = AppStateScope.of(context).birthdate;
    if (savedBirthdate != null) {
      _myDate = savedBirthdate;
    }
    _didInitFromProfile = true;
  }

  Future<void> _pickDate({
    required DateTime? currentValue,
    required ValueSetter<DateTime> onSelected,
  }) async {
    final initialDate = currentValue ?? DateTime(2000, 1, 1);
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Birth date',
    );
    if (selected != null) onSelected(selected);
  }

  void _calculate() {
    if (_myDate == null || _partnerDate == null) return;

    final mySign = ZodiacUtils.getZodiac(_myDate!);
    final partnerSign = ZodiacUtils.getZodiac(_partnerDate!);
    final score = CompatibilityData.calculateScore(mySign, partnerSign);

    setState(() {
      _mySign = mySign;
      _partnerSign = partnerSign;
      _score = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final canCalculate = _myDate != null && _partnerDate != null;
    final premiumText = _score == null
        ? ''
        : CompatibilityData.premiumDescription(_mySign, _partnerSign, _score!);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
        children: [
          Text('Compatibility Calculator', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text(
            'Calculate compatibility using two birth dates.',
            style: TextStyle(color: Color(0xFFAFB8DC)),
          ),
          const SizedBox(height: 20),
          _dateInput(
            title: 'Your birth date',
            date: _myDate,
            onTap: () => _pickDate(
              currentValue: _myDate,
              onSelected: (date) => setState(() => _myDate = date),
            ),
          ),
          const SizedBox(height: 12),
          _dateInput(
            title: 'Partner birth date',
            date: _partnerDate,
            onTap: () => _pickDate(
              currentValue: _partnerDate,
              onSelected: (date) => setState(() => _partnerDate = date),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canCalculate ? _calculate : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F7BFF),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Calculate'),
            ),
          ),
          if (!canCalculate) ...[
            const SizedBox(height: 10),
            const Text(
              'Select both dates to calculate compatibility.',
              style: TextStyle(color: Color(0xFFAFB8DC)),
            ),
          ],
          if (_score != null) ...[
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1020).withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2A335A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ZodiacUtils.displayName(_mySign)} + ${ZodiacUtils.displayName(_partnerSign)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_score%',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFBFC6FF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (appState.isPremium)
                    Text(premiumText, style: Theme.of(context).textTheme.bodyMedium)
                  else
                    const Text(
                      'Detailed explanation is available in Premium.',
                      style: TextStyle(color: Color(0xFFE0CCE9)),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dateInput({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final text = date == null
        ? 'Select a date'
        : '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1020).withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF283257)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF9EA8CD))),
                  const SizedBox(height: 5),
                  Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: Color(0xFF9EA8CD)),
          ],
        ),
      ),
    );
  }
}
