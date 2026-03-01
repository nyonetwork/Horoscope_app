import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';
import 'package:horoscope_app/widgets/app_page_header.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenPremium;

  const HomeScreen({
    super.key,
    required this.onOpenSettings,
    required this.onOpenPremium,
  });

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
              onTap: onOpenSettings,
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: appState.didCheckInToday
                ? const SizedBox.shrink()
                : _checkInCard(context, appState),
          ),
          if (!appState.didCheckInToday) const SizedBox(height: 14),
          _symbolHero(sign: sign),
          const SizedBox(height: 16),
          if (appState.isHoroscopeLoading && dailyData == null)
            _loadingCard()
          else if (dailyData == null)
            _missingContentCard(context, appState)
          else ...[
            _todayHeroCard(
              context,
              content:
                  dailyData['today'] ?? 'Your cosmic guidance is warming up.',
              sign: sign,
              mood: dailyData['today_mood'] ?? 'Mood is steady and clear.',
              career:
                  dailyData['today_career'] ??
                  'Career/Job: focus on one meaningful task.',
              love:
                  dailyData['today_love'] ??
                  'Love: a simple honest message helps today.',
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
              mood:
                  dailyData['yesterday_mood'] ?? 'Mood was balanced and calm.',
              career:
                  dailyData['yesterday_career'] ??
                  'Career/Job: your consistency helped progress.',
              love:
                  dailyData['yesterday_love'] ??
                  'Love: a warm check-in improved connection.',
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
                mood: dailyData['tomorrow_mood'] ?? 'Mood looks optimistic.',
                career:
                    dailyData['tomorrow_career'] ??
                    'Career/Job: set one practical priority.',
                love:
                    dailyData['tomorrow_love'] ??
                    'Love: clear words can strengthen the bond.',
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
    return Container(
      key: const ValueKey('check-in-card'),
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
              'Daily check-in is ready. Claim today to build your streak.',
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
            onPressed: appState.markDailyCheckIn,
            child: const Text('Check in'),
          ),
        ],
      ),
    );
  }

  Widget _todayHeroCard(
    BuildContext context, {
    required String content,
    required String sign,
    required String mood,
    required String career,
    required String love,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 14, end: 0),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, y, child) {
        return Transform.translate(offset: Offset(0, y), child: child);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openReadingOverlay(
          context,
          section: 'Today',
          sign: sign,
          general: content,
          emoji: '\u{2728}',
          mood: mood,
          career: career,
          love: love,
        ),
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
              const Row(
                children: [
                  Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFDDA5)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.open_in_full_rounded, size: 18),
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
                onPressed: onOpenSettings,
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
    required String mood,
    required String career,
    required String love,
  }) {
    final emoji = section == 'Yesterday'
        ? '\u{1FA90}'
        : section == 'Tomorrow'
        ? '\u{1F319}'
        : '\u{2728}';

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _openReadingOverlay(
        context,
        section: section,
        sign: sign,
        general: content,
        emoji: emoji,
        mood: mood,
        career: career,
        love: love,
      ),
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
                const Icon(Icons.open_in_full_rounded, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
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
            'Upgrade to Premium to unlock tomorrow.',
            style: TextStyle(color: Color(0xFFE6C9D8), fontSize: 12),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onOpenPremium,
            icon: const Icon(Icons.stars_rounded),
            label: const Text('Upgrade to Premium'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFD9A4),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openReadingOverlay(
    BuildContext context, {
    required String section,
    required String sign,
    required String general,
    required String emoji,
    required String mood,
    required String career,
    required String love,
  }) async {
    await showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Reading',
      barrierDismissible: true,
      barrierColor: const Color(0xB50A0F22),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1026),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF334B88)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '$section Reading',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFF2F406F)),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                        children: [
                          _detailBlock(
                            title: 'General Horoscope',
                            content: general,
                          ),
                          const SizedBox(height: 12),
                          _detailBlock(title: 'Mood', content: mood),
                          const SizedBox(height: 12),
                          _detailBlock(title: 'Career', content: career),
                          const SizedBox(height: 12),
                          _detailBlock(title: 'Love', content: love),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  Widget _detailBlock({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111832).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF344A83)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(color: Color(0xFFE3EAFF), height: 1.52),
          ),
        ],
      ),
    );
  }
}
