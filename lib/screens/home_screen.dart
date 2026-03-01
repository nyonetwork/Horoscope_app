import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';
import 'package:horoscope_app/widgets/app_page_header.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;

  const HomeScreen({super.key, required this.onOpenSettings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _expandedSection = 'Today';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final sign = appState.selectedZodiac;
    final dailyData = appState.dailyHoroscope;
    final now = DateTime.now();
    final formattedDate =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: [
          AppPageHeader(
            section: 'Home',
            title: 'Daily Horoscope',
            subtitle: 'Your personalized reading for today.',
            trailing: HeaderIconButton(
              icon: Icons.settings_rounded,
              onTap: widget.onOpenSettings,
              tooltip: 'Settings',
            ),
            chips: [
              HeaderChip(
                icon: Icons.auto_awesome_rounded,
                label: ZodiacUtils.displayName(sign),
              ),
              HeaderChip(icon: Icons.event_rounded, label: formattedDate),
              HeaderChip(
                icon: Icons.local_fire_department_rounded,
                label: '${appState.streakCount} day streak',
                color: const Color(0xFFFFD49D),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _checkInCard(context, appState),
          const SizedBox(height: 14),
          _symbolHero(sign: sign),
          const SizedBox(height: 16),
          if (appState.isHoroscopeLoading && dailyData == null)
            _loadingCard()
          else if (dailyData == null)
            _missingContentCard(context, appState)
          else ...[
            _todayHeroCard(
              content:
                  dailyData['today'] ?? 'Your cosmic guidance is warming up.',
              sign: sign,
            ),
            const SizedBox(height: 20),
            const Text(
              'More guidance',
              style: TextStyle(
                color: Color(0xFFCED8FB),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _forecastCard(
              context,
              section: 'Yesterday',
              content: dailyData['yesterday'] ?? 'No update for yesterday yet.',
              icon: Icons.history_toggle_off_rounded,
              accent: const Color(0xFFBBD1FF),
              sign: sign,
            ),
            const SizedBox(height: 14),
            if (appState.isPremium)
              _forecastCard(
                context,
                section: 'Tomorrow',
                content: dailyData['tomorrow'] ?? 'Tomorrow is still forming.',
                icon: Icons.auto_awesome_rounded,
                accent: const Color(0xFFE2C7FF),
                sign: sign,
              )
            else
              _lockedTomorrowCard(context),
          ],
        ],
      ),
    );
  }

  Widget _symbolHero({required String sign}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.94, end: 1.0),
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Center(
        child: Container(
          width: 130,
          height: 130,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8CB4FF), Color(0xFF6B72FF), Color(0xFF412E77)],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x802E4DAD),
                blurRadius: 38,
                spreadRadius: 4,
              ),
              BoxShadow(color: Color(0x502D1E52), blurRadius: 14),
            ],
          ),
          child: Text(
            ZodiacUtils.symbol(sign),
            style: const TextStyle(
              fontSize: 68,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkInCard(BuildContext context, AppState appState) {
    final checkedIn = appState.didCheckInToday;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1228).withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF33457F)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: Color(0xFFFFD49D)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              checkedIn
                  ? 'Checked in today. Keep your streak alive tomorrow.'
                  : 'Daily check-in is ready. Claim today to build your streak.',
              style: const TextStyle(color: Color(0xFFE3EAFF), height: 1.45),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(84, 38),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: checkedIn ? null : appState.markDailyCheckIn,
            child: Text(checkedIn ? 'Done' : 'Check in'),
          ),
        ],
      ),
    );
  }

  Widget _todayHeroCard({required String content, required String sign}) {
    final isExpanded = _expandedSection == 'Today';
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 14, end: 0),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, y, child) {
        return Transform.translate(offset: Offset(0, y), child: child);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _toggleSection('Today'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF283A74), Color(0xFF1D2A57), Color(0xFF121D41)],
            ),
            border: Border.all(
              color: const Color(0xFF8EA5FF).withValues(alpha: 0.65),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x7A526DDB),
                blurRadius: 28,
                spreadRadius: 2,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFDDA5)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                content,
                style: const TextStyle(
                  color: Color(0xFFF0F4FF),
                  height: 1.65,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 220),
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _detailPanel(section: 'Today', emoji: '?', sign: sign),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _missingContentCard(BuildContext context, AppState appState) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1930).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF524B80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'We could not load your daily reading.',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            appState.horoscopeError ??
                'Try again or refresh your sign from Settings.',
            style: const TextStyle(color: Color(0xFFE1E7FF), height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () =>
                    appState.loadDailyHoroscope(forceRefresh: true),
                child: const Text('Retry'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: widget.onOpenSettings,
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF101735).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF34457E)),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Loading your daily reading...',
              style: TextStyle(color: Color(0xFFE4EBFF), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forecastCard(
    BuildContext context, {
    required String section,
    required String content,
    required IconData icon,
    required Color accent,
    required String sign,
  }) {
    final isExpanded = _expandedSection == section;
    final emoji = section == 'Yesterday'
        ? '??'
        : section == 'Tomorrow'
        ? '??'
        : '?';

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _toggleSection(section),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xEE131B38), Color(0xEE0D1430), Color(0xEE090F25)],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.40), width: 1.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _detailPanel(section: section, emoji: emoji, sign: sign),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }

  Widget _lockedTomorrowCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xEE281C36), Color(0xEE1B1629), Color(0xEE130F21)],
        ),
        border: Border.all(color: const Color(0x88FFC28F), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_rounded, color: Color(0xFFFFD9A4)),
              SizedBox(width: 8),
              Text(
                'Tomorrow (Premium)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Tomorrow\'s reading is locked in free mode.',
            style: TextStyle(color: Color(0xFFF4E5F0), height: 1.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Open Settings to enable Premium.',
            style: TextStyle(color: Color(0xFFE6C9D8), fontSize: 12),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: widget.onOpenSettings,
            icon: const Icon(Icons.stars_rounded),
            label: const Text('Go to Settings to activate Premium'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFD9A4),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailPanel({
    required String section,
    required String emoji,
    required String sign,
  }) {
    final mood = _pick(
      [
        'Optimistic and focused',
        'Calm but determined',
        'Curious and energetic',
        'Emotionally clear',
        'Bold and open-minded',
      ],
      sign,
      section,
      1,
    );
    final career = _pick(
      [
        'A small initiative can get noticed.',
        'Team communication works in your favor.',
        'Finish one key task before multitasking.',
        'A practical decision saves time.',
        'Good moment to pitch an idea.',
      ],
      sign,
      section,
      2,
    );
    final love = _pick(
      [
        'Honest words will land well.',
        'A simple check-in strengthens connection.',
        'Stay playful and light in conversations.',
        'Listening first will improve the vibe.',
        'A thoughtful message can shift the day.',
      ],
      sign,
      section,
      3,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x59101831),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A4D86)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$emoji Quick detail',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE8EEFF),
            ),
          ),
          const SizedBox(height: 8),
          _detailLine('Mood', mood),
          const SizedBox(height: 4),
          _detailLine('Career', career),
          const SizedBox(height: 4),
          _detailLine('Love', love),
        ],
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFE6ECFF),
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Color(0xFFD6DFFD), height: 1.45),
          ),
        ],
      ),
    );
  }

  String _pick(List<String> options, String sign, String section, int salt) {
    final signScore = sign.codeUnits.fold<int>(0, (sum, c) => sum + c);
    final sectionScore = section.codeUnits.fold<int>(0, (sum, c) => sum + c);
    final index = (signScore + sectionScore + (salt * 13)) % options.length;
    return options[index];
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSection = _expandedSection == section ? '' : section;
    });
  }
}
