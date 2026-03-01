class HoroscopeDatabase2026 {
  static final Map<String, Map<String, Map<String, String>>> _database =
      _buildDatabase();

  static final Map<String, _SignProfile> _profiles = {
    'Aries': const _SignProfile(
      energy: 'bold',
      focus: 'quick action',
      vibe: 'confident',
    ),
    'Taurus': const _SignProfile(
      energy: 'steady',
      focus: 'practical progress',
      vibe: 'grounded',
    ),
    'Gemini': const _SignProfile(
      energy: 'curious',
      focus: 'smart communication',
      vibe: 'adaptable',
    ),
    'Cancer': const _SignProfile(
      energy: 'sensitive',
      focus: 'emotional clarity',
      vibe: 'protective',
    ),
    'Leo': const _SignProfile(
      energy: 'radiant',
      focus: 'visible leadership',
      vibe: 'expressive',
    ),
    'Virgo': const _SignProfile(
      energy: 'precise',
      focus: 'structured effort',
      vibe: 'disciplined',
    ),
    'Libra': const _SignProfile(
      energy: 'balanced',
      focus: 'fair decisions',
      vibe: 'harmonious',
    ),
    'Scorpio': const _SignProfile(
      energy: 'intense',
      focus: 'deep focus',
      vibe: 'magnetic',
    ),
    'Sagittarius': const _SignProfile(
      energy: 'adventurous',
      focus: 'growth and learning',
      vibe: 'optimistic',
    ),
    'Capricorn': const _SignProfile(
      energy: 'determined',
      focus: 'long-term goals',
      vibe: 'mature',
    ),
    'Aquarius': const _SignProfile(
      energy: 'inventive',
      focus: 'original ideas',
      vibe: 'independent',
    ),
    'Pisces': const _SignProfile(
      energy: 'intuitive',
      focus: 'creative flow',
      vibe: 'gentle',
    ),
  };

  static const List<String> _todayPrimary = [
    'Today rewards a {focus} mindset and clean priorities.',
    'Your {energy} energy is strongest when directed toward one meaningful target.',
    'A {vibe} tone helps you move through conversations with less friction.',
    'The day favors practical momentum over perfection, which suits your {focus} style.',
    'You get better results by acting early while your {energy} is fresh.',
    'Your instinct is right today, but it works best with a simple plan behind it.',
    'Small strategic moves are more powerful than dramatic changes right now.',
    'Clarity comes fast once you decide what matters most this morning.',
    'Your {vibe} approach can settle tension and open real progress.',
    'Keep your pace steady and let your {focus} carry the day.',
  ];

  static const List<String> _yesterdayPrimary = [
    'Yesterday, your {energy} approach helped you avoid unnecessary friction.',
    'You handled yesterday with a {vibe} response that improved your momentum.',
    'Yesterday rewarded your {focus}; even small decisions had useful impact.',
    'Your calm pacing yesterday created more progress than it first seemed.',
    'You closed yesterday with better clarity than you started with.',
    'The way you prioritized yesterday made today easier to manage.',
    'Yesterday was strongest when you stayed practical and avoided overexplaining.',
    'Your {focus} was noticeable yesterday, especially in routine tasks.',
  ];

  static const List<String> _tomorrowPrimary = [
    'Tomorrow favors preparation and one clear decision at the right time.',
    'A {vibe} approach tomorrow can open useful support from others.',
    'Tomorrow works best when your {focus} is narrowed to one key objective.',
    'Your {energy} may rise quickly tomorrow, so use it on high-impact work first.',
    'Expect better flow tomorrow if you simplify your schedule today.',
    'Tomorrow gives you room to reset pace and improve direction.',
    'A practical move tomorrow is likely to produce visible results.',
    'Your best tomorrow starts with clear boundaries and fewer distractions.',
  ];

  static const List<String> _generalSecondary = [
    'Keep communication direct, and let consistency do the heavy lifting.',
    'You do not need to force outcomes; steady follow-through is enough.',
    'Protect your attention and avoid tasks that dilute your momentum.',
    'The more specific your plan, the easier your progress becomes.',
    'Quiet confidence is more effective than overcommitting right now.',
    'One completed priority is worth more than five half-finished ideas.',
    'Trust your pace and focus on what is actually in your control.',
    'Use short check-ins to keep alignment without losing energy.',
    'Good timing matters today, so act when your direction is clear.',
    'Simplicity is your advantage; reduce noise and move with intention.',
  ];

  static const List<String> _moodPrimary = [
    'Emotionally, you are likely to feel {vibe} with a steady undercurrent of focus.',
    'Your mood may shift between calm and {energy}, so structure helps.',
    'You are in a better emotional place when your day has clear edges.',
    'There is a grounded tone to your mood that supports smart decisions.',
    'You may feel more sensitive to distractions; protect your mental space.',
    'A balanced routine helps your mood stay clear and productive.',
    'Inner confidence increases when you avoid unnecessary comparison.',
    'Your emotional rhythm is stronger than usual once you settle your priorities.',
  ];

  static const List<String> _moodSecondary = [
    'If pressure rises, slow your pace for ten minutes and reset your intent.',
    'A short break and one clear next step will quickly restore balance.',
    'Name what matters most, and your stress level will drop naturally.',
    'Try not to absorb every outside opinion; your own signal is enough.',
    'Keep expectations realistic and let your consistency build confidence.',
    'A quieter environment will noticeably improve your mental clarity.',
  ];

  static const List<String> _careerPrimary = [
    'At work, your {focus} gives you an advantage in planning and execution.',
    'Professional progress improves when you lead with clarity instead of speed.',
    'Your output is strongest when you complete one high-impact task first.',
    'Team dynamics improve when you share concise updates early.',
    'You may get recognition through reliability rather than visibility.',
    'A practical decision now can save significant time later.',
    'Your discipline helps convert scattered tasks into measurable progress.',
    'This is a good window to refine process, not just push volume.',
  ];

  static const List<String> _careerSecondary = [
    'Avoid overloading your list; one finished objective will move everything forward.',
    'If collaboration is needed, define ownership early and keep communication simple.',
    'Protect deep-work time before meetings begin to maintain momentum.',
    'Document key decisions briefly so you do not repeat the same conversation.',
    'Use a two-step plan: finish essentials, then improve details.',
    'Say no to low-value tasks and prioritize outcomes over activity.',
  ];

  static const List<String> _lovePrimary = [
    'In relationships, a {vibe} tone creates trust faster than perfect wording.',
    'Your connections respond well to simple honesty and steady presence.',
    'Emotional closeness grows when you speak clearly and listen without rushing.',
    'A thoughtful check-in can shift the relationship climate in a positive way.',
    'Affection feels stronger when expectations are spoken, not assumed.',
    'Warm consistency matters more now than dramatic gestures.',
    'You are likely to read emotional signals accurately if you stay patient.',
    'Keep conversations direct and kind; this improves mutual understanding quickly.',
  ];

  static const List<String> _loveSecondary = [
    'If tension appears, address the issue early with calm language.',
    'A short genuine message can have more impact than a long explanation.',
    'Show up with attention, not solutions, and connection improves naturally.',
    'Focus on reassurance and clarity rather than proving a point.',
    'Ask one real question and listen fully before replying.',
    'Keep promises small and consistent to build stronger trust.',
  ];

  static Map<String, String>? getDailyBundle({
    required String sign,
    required DateTime date,
  }) {
    if (date.year != 2026) return null;
    return _database[_dateKey(date)]?[sign];
  }

  static Map<String, Map<String, Map<String, String>>> _buildDatabase() {
    final db = <String, Map<String, Map<String, String>>>{};
    final start = DateTime(2026, 1, 1);
    final end = DateTime(2026, 12, 31);

    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      final dayMap = <String, Map<String, String>>{};
      for (final entry in _profiles.entries) {
        dayMap[entry.key] = _buildBundle(
          sign: entry.key,
          profile: entry.value,
          date: d,
        );
      }
      db[_dateKey(d)] = dayMap;
    }
    return db;
  }

  static Map<String, String> _buildBundle({
    required String sign,
    required _SignProfile profile,
    required DateTime date,
  }) {
    final yesterday = date.subtract(const Duration(days: 1));
    final tomorrow = date.add(const Duration(days: 1));

    return {
      'yesterday': _buildGeneral(yesterday, sign, profile, scope: 'yesterday'),
      'today': _buildGeneral(date, sign, profile, scope: 'today'),
      'tomorrow': _buildGeneral(tomorrow, sign, profile, scope: 'tomorrow'),
      'yesterday_mood': _buildDetail(yesterday, sign, profile, kind: 'mood'),
      'yesterday_career': _buildDetail(
        yesterday,
        sign,
        profile,
        kind: 'career',
      ),
      'yesterday_love': _buildDetail(yesterday, sign, profile, kind: 'love'),
      'today_mood': _buildDetail(date, sign, profile, kind: 'mood'),
      'today_career': _buildDetail(date, sign, profile, kind: 'career'),
      'today_love': _buildDetail(date, sign, profile, kind: 'love'),
      'tomorrow_mood': _buildDetail(tomorrow, sign, profile, kind: 'mood'),
      'tomorrow_career': _buildDetail(tomorrow, sign, profile, kind: 'career'),
      'tomorrow_love': _buildDetail(tomorrow, sign, profile, kind: 'love'),
    };
  }

  static String _buildGeneral(
    DateTime date,
    String sign,
    _SignProfile profile, {
    required String scope,
  }) {
    final primaryTemplates = scope == 'yesterday'
        ? _yesterdayPrimary
        : scope == 'tomorrow'
        ? _tomorrowPrimary
        : _todayPrimary;

    final first = _pick(
      templates: primaryTemplates,
      date: date,
      sign: sign,
      salt: scope == 'yesterday'
          ? 11
          : scope == 'tomorrow'
          ? 29
          : 17,
    );
    final second = _pick(
      templates: _generalSecondary,
      date: date,
      sign: sign,
      salt: scope == 'yesterday'
          ? 43
          : scope == 'tomorrow'
          ? 59
          : 37,
    );
    return _applyProfile('$first $second', profile);
  }

  static String _buildDetail(
    DateTime date,
    String sign,
    _SignProfile profile, {
    required String kind,
  }) {
    final primaryTemplates = kind == 'mood'
        ? _moodPrimary
        : kind == 'career'
        ? _careerPrimary
        : _lovePrimary;
    final secondaryTemplates = kind == 'mood'
        ? _moodSecondary
        : kind == 'career'
        ? _careerSecondary
        : _loveSecondary;

    final first = _pick(
      templates: primaryTemplates,
      date: date,
      sign: sign,
      salt: kind == 'mood'
          ? 71
          : kind == 'career'
          ? 83
          : 97,
    );
    final second = _pick(
      templates: secondaryTemplates,
      date: date,
      sign: sign,
      salt: kind == 'mood'
          ? 101
          : kind == 'career'
          ? 113
          : 127,
    );

    return _applyProfile('$first $second', profile);
  }

  static String _pick({
    required List<String> templates,
    required DateTime date,
    required String sign,
    required int salt,
  }) {
    final dateKey = date.year * 10000 + date.month * 100 + date.day;
    final signKey = sign.codeUnits.fold<int>(0, (sum, value) => sum + value);
    final index = (dateKey + signKey + salt) % templates.length;
    return templates[index];
  }

  static String _applyProfile(String input, _SignProfile profile) {
    return input
        .replaceAll('{energy}', profile.energy)
        .replaceAll('{focus}', profile.focus)
        .replaceAll('{vibe}', profile.vibe);
  }

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _SignProfile {
  final String energy;
  final String focus;
  final String vibe;

  const _SignProfile({
    required this.energy,
    required this.focus,
    required this.vibe,
  });
}
