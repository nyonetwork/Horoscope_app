class CompatibilityData {
  static const Map<String, int> elementScore = {
    'same': 88,
    'friendly': 76,
    'neutral': 62,
    'challenging': 49,
  };

  static const Map<String, String> signElement = {
    'Aries': 'fire',
    'Leo': 'fire',
    'Sagittarius': 'fire',
    'Taurus': 'earth',
    'Virgo': 'earth',
    'Capricorn': 'earth',
    'Gemini': 'air',
    'Libra': 'air',
    'Aquarius': 'air',
    'Cancer': 'water',
    'Scorpio': 'water',
    'Pisces': 'water',
  };

  static int calculateScore(String first, String second) {
    if (first == second) return elementScore['same']!;

    final firstElement = signElement[first]!;
    final secondElement = signElement[second]!;
    final key = '$firstElement-$secondElement';

    const relation = {
      'fire-air': 'friendly',
      'air-fire': 'friendly',
      'earth-water': 'friendly',
      'water-earth': 'friendly',
      'fire-fire': 'same',
      'earth-earth': 'same',
      'air-air': 'same',
      'water-water': 'same',
      'fire-earth': 'neutral',
      'earth-fire': 'neutral',
      'air-water': 'neutral',
      'water-air': 'neutral',
      'fire-water': 'challenging',
      'water-fire': 'challenging',
      'earth-air': 'challenging',
      'air-earth': 'challenging',
    };

    final scoreBand = relation[key] ?? 'neutral';
    return elementScore[scoreBand]!;
  }

  static String premiumDescription(String first, String second, int score) {
    if (score >= 85) {
      return '$first and $second have very strong energetic alignment. '
          'You naturally support each other\'s emotional and life direction.';
    }
    if (score >= 70) {
      return '$first and $second are stable together with strong growth potential. '
          'Clear communication keeps this bond resilient over time.';
    }
    if (score >= 55) {
      return '$first and $second are moderately compatible. '
          'Listening carefully and setting expectations will improve this connection.';
    }
    return '$first and $second may experience friction in rhythm and needs. '
        'With patience and direct conversation, the relationship can still become steady.';
  }
}
