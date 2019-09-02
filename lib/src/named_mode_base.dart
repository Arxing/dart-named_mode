class NamedMode {
  final String _value;
  final String _name;

  const NamedMode._(this._value, this._name);

  factory NamedMode(String value) {
    return values.firstWhere((o) => o.value == value, orElse: () => unknown);
  }

  String get value => _value;

  String get name => _name;

  static const String _LOWER_WORD = '[a-z\$][a-z0-9]*';

  static const String _UPPER_WORD = '[A-Z\$][A-Z0-9]*';

  static const String _FIRST_UPPER_WORD = '[A-Z\$][a-z0-9]*';

  static List<NamedMode> get values => [an_apple, AN_APPLE, anApple, AnApple];

  static List<String> get names => [an_apple.name, AN_APPLE.name, anApple.name, AnApple.name];

  List<String> split(String input) {
    switch (this) {
      case an_apple:
      case AN_APPLE:
        return input.split('_').map((o) => o.toLowerCase()).toList();
      case anApple:
        var matches = RegExp('^($_LOWER_WORD)(($_FIRST_UPPER_WORD)*)\$').allMatches(input).first;
        String head = matches.group(1);
        String fullTail = matches.group(2);
        var allMatches2 = RegExp('($_FIRST_UPPER_WORD)').allMatches(fullTail);
        var tails = allMatches2.map((o) => o.group(1)).toList();
        return ([head]..addAll(tails)).map((o) => o.toLowerCase()).toList();
      case AnApple:
        return RegExp('($_FIRST_UPPER_WORD)').allMatches(input).map((o) => o.group(1)).toList();
    }
    return [];
  }

  ///
  static const String _an_apple = '^($_LOWER_WORD)(_$_LOWER_WORD)*\$';
  static const an_apple = NamedMode._(_an_apple, 'an_apple');

  ///
  static const String _AN_APPLE = '^($_UPPER_WORD)(_$_UPPER_WORD)*\$';
  static const AN_APPLE = NamedMode._(_AN_APPLE, 'AN_APPLE');

  ///
  static const String _anApple = '^($_LOWER_WORD)($_FIRST_UPPER_WORD)*\$';
  static const anApple = NamedMode._(_anApple, 'anApple');

  ///
  static const String _AnApple = '^($_FIRST_UPPER_WORD)+\$';
  static const AnApple = NamedMode._(_AnApple, 'AnApple');

  ///
  static const String _unknown = '';
  static const unknown = NamedMode._(_unknown, 'unknown');
}

String renameToOtherMode(String src, NamedMode mode) {
  if (src == null || src.isEmpty) return '';
  NamedMode oldMode = resolveNamedMode(src);
  if (oldMode == NamedMode.unknown) {
    print('cannot resolve named mode of string:"$src"');
    return src;
  }
  return combineWithNamedMode(oldMode.split(src), mode);
}

String renameTo__an_apple(String src) {
  return renameToOtherMode(src, NamedMode.an_apple);
}

String renameTo__AN_APPLE(String src) {
  return renameToOtherMode(src, NamedMode.AN_APPLE);
}

String renameTo__anApple(String src) {
  return renameToOtherMode(src, NamedMode.anApple);
}

String renameTo__AnApple(String src) {
  return renameToOtherMode(src, NamedMode.AnApple);
}

NamedMode resolveNamedMode(String src) {
  return NamedMode.values.firstWhere((m) => RegExp(m.value).hasMatch(src), orElse: () => NamedMode.unknown);
}

String combineWithNamedMode(List<String> segments, NamedMode mode) {
  if (segments.isEmpty) return null;
  switch (mode) {
    case NamedMode.an_apple:
      return segments.map((o) => changeFirstChar(o, toUpper: false)).join('_');
    case NamedMode.AN_APPLE:
      return segments.map((o) => o.toUpperCase()).join('_');
    case NamedMode.anApple:
      return segments.length == 1
          ? changeFirstChar(segments[0], toUpper: false)
          : changeFirstChar(segments[0], toUpper: false) +
          segments.skip(1).map((o) => changeFirstChar(o, toUpper: true)).join('');
    case NamedMode.AnApple:
      return segments.length == 1
          ? changeFirstChar(segments[0], toUpper: true)
          : changeFirstChar(segments[0], toUpper: true) + segments.skip(1).map((o) => changeFirstChar(o, toUpper: true)).join('');
  }
  return null;
}

String changeFirstChar(String s, {bool toUpper = true}) {
  if (s == null || s.isEmpty) return '';
  if (s.length == 1) return toUpper ? s.toUpperCase() : s.toLowerCase();
  return (toUpper ? s.toUpperCase() : s.toLowerCase()).substring(0, 1) + s.substring(1);
}
