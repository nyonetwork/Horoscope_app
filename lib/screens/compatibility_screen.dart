import 'package:flutter/material.dart';
import 'package:horoscope_app/data/compatibility_data.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';
import 'package:horoscope_app/widgets/app_page_header.dart';
import 'package:horoscope_app/widgets/birth_date_picker_sheet.dart';

class CompatibilityScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenPremium;

  const CompatibilityScreen({
    super.key,
    required this.onOpenSettings,
    required this.onOpenPremium,
  });

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  DateTime? _myDate;
  DateTime? _partnerDate;
  int? _score;
  String _mySign = '';
  String _partnerSign = '';
  bool _isCalculating = false;
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
    final selected = await showBirthDatePickerSheet(
      context,
      initialDate: initialDate,
      minimumDate: DateTime(1950),
      maximumDate: DateTime.now(),
    );
    if (selected != null) onSelected(selected);
  }

  Future<void> _calculate() async {
    if (_myDate == null || _partnerDate == null || _isCalculating) return;

    setState(() {
      _isCalculating = true;
      _score = null;
    });

    // Brief loading state for better feedback and perceived interaction.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final mySign = ZodiacUtils.getZodiac(_myDate!);
    final partnerSign = ZodiacUtils.getZodiac(_partnerDate!);
    final score = CompatibilityData.calculateScore(
      mySign,
      partnerSign,
      firstBirthdate: _myDate,
      secondBirthdate: _partnerDate,
    );

    if (!mounted) return;
    setState(() {
      _mySign = mySign;
      _partnerSign = partnerSign;
      _score = score;
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final canCalculate = _myDate != null && _partnerDate != null;
    final now = DateTime.now();
    final formattedDate =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
    final premiumText = _score == null
        ? ''
        : CompatibilityData.premiumDescription(_mySign, _partnerSign, _score!);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
        children: [
          AppPageHeader(
            section: 'Compatibility',
            title: 'Compatibility Calculator',
            subtitle: 'Calculate compatibility using two birth dates.',
            trailing: HeaderIconButton(
              icon: Icons.settings_rounded,
              onTap: widget.onOpenSettings,
              tooltip: 'Settings',
            ),
            chips: [
              HeaderChip(icon: Icons.event_rounded, label: formattedDate),
              HeaderChip(
                icon: Icons.auto_awesome_rounded,
                label: ZodiacUtils.displayName(appState.selectedZodiac),
              ),
            ],
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
              onPressed: canCalculate && !_isCalculating ? _calculate : null,
              child: _isCalculating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Calculate'),
            ),
          ),
          if (_isCalculating) ...[
            const SizedBox(height: 12),
            _connectingCard(),
          ],
          if (!canCalculate) ...[
            const SizedBox(height: 10),
            _placeholderCard(
              icon: Icons.favorite_outline_rounded,
              title: 'Select both birth dates to calculate your match.',
              subtitle:
                  'Your result will appear here with score and explanation.',
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
                    Text(
                      premiumText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detailed explanation is available in Premium.',
                          style: TextStyle(
                            color: Color(0xFFF0D9F9),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: widget.onOpenPremium,
                          icon: const Icon(Icons.workspace_premium_rounded),
                          label: const Text('Unlock Premium'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFE8D6FF),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
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
    final sign = date == null ? null : ZodiacUtils.getZodiac(date);
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
                  Text(title, style: const TextStyle(color: Color(0xFFB3BCE2))),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      if (sign != null) ...[
                        Text(
                          ZodiacUtils.symbol(sign),
                          style: const TextStyle(fontSize: 18, height: 1),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE3E9FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (sign != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      ZodiacUtils.displayName(sign),
                      style: const TextStyle(
                        color: Color(0xFFBAC6EE),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: Color(0xFFAFB8DE)),
          ],
        ),
      ),
    );
  }

  Widget _placeholderCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1020).withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B345A)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC5D0FA)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE2E9FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFCFD7F8),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectingCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1020).withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A4A87)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Connecting energies and calculating your match...',
                style: TextStyle(color: Color(0xFFD8E0FF), height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
