class CompatibilityData {
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

  static const Map<String, String> signModality = {
    'Aries': 'cardinal',
    'Cancer': 'cardinal',
    'Libra': 'cardinal',
    'Capricorn': 'cardinal',
    'Taurus': 'fixed',
    'Leo': 'fixed',
    'Scorpio': 'fixed',
    'Aquarius': 'fixed',
    'Gemini': 'mutable',
    'Virgo': 'mutable',
    'Sagittarius': 'mutable',
    'Pisces': 'mutable',
  };

  static const Map<String, String> signPolarity = {
    'Aries': 'yang',
    'Gemini': 'yang',
    'Leo': 'yang',
    'Libra': 'yang',
    'Sagittarius': 'yang',
    'Aquarius': 'yang',
    'Taurus': 'yin',
    'Cancer': 'yin',
    'Virgo': 'yin',
    'Scorpio': 'yin',
    'Capricorn': 'yin',
    'Pisces': 'yin',
  };

  static const Map<String, int> signIndex = {
    'Aries': 0,
    'Taurus': 1,
    'Gemini': 2,
    'Cancer': 3,
    'Leo': 4,
    'Virgo': 5,
    'Libra': 6,
    'Scorpio': 7,
    'Sagittarius': 8,
    'Capricorn': 9,
    'Aquarius': 10,
    'Pisces': 11,
  };

  static int calculateScore(
    String first,
    String second, {
    DateTime? firstBirthdate,
    DateTime? secondBirthdate,
  }) {
    if (first == second) return 91;

    final firstElement = signElement[first] ?? 'air';
    final secondElement = signElement[second] ?? 'air';
    final firstModality = signModality[first] ?? 'mutable';
    final secondModality = signModality[second] ?? 'mutable';
    final firstPolarity = signPolarity[first] ?? 'yang';
    final secondPolarity = signPolarity[second] ?? 'yin';
    final firstIndex = signIndex[first] ?? 0;
    final secondIndex = signIndex[second] ?? 6;

    final elementDelta = _elementDelta(firstElement, secondElement);
    final modalityDelta = _modalityDelta(firstModality, secondModality);
    final polarityDelta = firstPolarity == secondPolarity ? -2 : 4;
    final angleDelta = _angleHarmony(firstIndex, secondIndex);

    final calendarDelta = _calendarDelta(firstBirthdate, secondBirthdate);
    final total =
        56 +
        elementDelta +
        modalityDelta +
        polarityDelta +
        angleDelta +
        calendarDelta;
    return total.clamp(35, 98);
  }

  static int _calendarDelta(DateTime? first, DateTime? second) {
    if (first == null || second == null) return 0;

    final dayDelta = _dayDelta(first.day, second.day);
    final monthDelta = _monthDelta(first.month, second.month);
    final yearDelta = _yearDelta(first.year, second.year);
    final lifePathDelta = _lifePathDelta(first, second);

    return dayDelta + monthDelta + yearDelta + lifePathDelta;
  }

  static int _elementDelta(String first, String second) {
    if (first == second) return 18;

    final key = '$first-$second';
    const table = {
      'fire-air': 13,
      'air-fire': 13,
      'earth-water': 13,
      'water-earth': 13,
      'fire-earth': 7,
      'earth-fire': 7,
      'air-water': 4,
      'water-air': 4,
      'fire-water': -7,
      'water-fire': -7,
      'earth-air': -6,
      'air-earth': -6,
    };
    return table[key] ?? 0;
  }

  static int _modalityDelta(String first, String second) {
    if (first == second) return -3;

    const supportivePairs = {'cardinal-mutable', 'mutable-cardinal'};
    if (supportivePairs.contains('$first-$second')) return 3;
    return 0;
  }

  static int _angleHarmony(int first, int second) {
    final rawDistance = (first - second).abs();
    final stepDistance = rawDistance > 6 ? 12 - rawDistance : rawDistance;
    const byDistance = {
      0: 12,
      1: -4,
      2: 7,
      3: 4,
      4: 10,
      5: -2,
      6: 2,
    };
    return byDistance[stepDistance] ?? 0;
  }

  static int _dayDelta(int firstDay, int secondDay) {
    final distance = (firstDay - secondDay).abs();
    if (distance == 0) return 4;
    if (distance <= 2) return 2;
    if (distance <= 7) return 1;
    if (distance >= 20) return -1;
    return 0;
  }

  static int _monthDelta(int firstMonth, int secondMonth) {
    final rawDistance = (firstMonth - secondMonth).abs();
    final distance = rawDistance > 6 ? 12 - rawDistance : rawDistance;
    if (distance == 0) return 3;
    if (distance == 1) return 2;
    if (distance == 2) return 1;
    if (distance == 6) return -1;
    return 0;
  }

  static int _yearDelta(int firstYear, int secondYear) {
    final gap = (firstYear - secondYear).abs();
    if (gap <= 1) return 2;
    if (gap <= 4) return 1;
    if (gap <= 10) return 0;
    if (gap <= 16) return -1;
    return -2;
  }

  static int _lifePathDelta(DateTime first, DateTime second) {
    final firstPath = _digitRoot(first.year + first.month + first.day);
    final secondPath = _digitRoot(second.year + second.month + second.day);
    final distance = (firstPath - secondPath).abs();
    if (distance == 0) return 2;
    if (distance == 1 || distance == 8) return 1;
    if (distance == 4 || distance == 5) return -1;
    return 0;
  }

  static int _digitRoot(int value) {
    var current = value.abs();
    while (current >= 10) {
      var next = 0;
      while (current > 0) {
        next += current % 10;
        current ~/= 10;
      }
      current = next;
    }
    return current;
  }

  static String premiumDescription(String first, String second, int score) {
    if (score >= 85) {
      return '$first ба $second маш хүчтэй энергийн нийцтэй байна. '
          'Та хоёр бие биеийнхээ сэтгэл болон амьдралын чиглэлийг байгалиараа дэмждэг.';
    }
    if (score >= 70) {
      return '$first ба $second тогтвортой хослол бөгөөд өсөх боломж өндөр. '
          'Тодорхой харилцаа энэ холбоог урт хугацаанд бат бөх байлгана.';
    }
    if (score >= 55) {
      return '$first ба $second дунд түвшний зохицолтой байна. '
          'Сонсох чадвар болон хүлээлтээ зөв тохируулах нь харилцааг сайжруулна.';
    }
    return '$first ба $second-ийн хэмнэл, хэрэгцээ заримдаа зөрчилдөж болно. '
        'Тэвчээртэй, шууд ярилцсанаар энэ харилцаа тогтвортой болж чадна.';
  }
}
