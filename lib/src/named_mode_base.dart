import 'dart:math';

class NamedMode {
  final String _value;
  final String _name;
  final int _priority;

  const NamedMode._(this._value, this._name, this._priority);

  factory NamedMode(String value) {
    return values.firstWhere((o) => o.value == value, orElse: () => unknown);
  }

  static NamedMode parseOn(String src) {
    return values.firstWhere((m) => RegExp(m.value).hasMatch(src), orElse: () => NamedMode.unknown);
  }

  String get value => _value;

  String get name => _name;

  static const String _LOWER_WORD = '[a-z\$][a-z0-9]*';

  static const String _UPPER_WORD = '[A-Z\$][A-Z0-9]*';

  static const String _FIRST_UPPER_WORD = '[A-Z\$][a-z0-9]*';

  static const String _ANY_WORD_BEGIN_NOT_NUMBER = '[a-zA-Z\$_][a-zA-Z0-9\$_]*';

  static const String _ANY_WORD = '[a-zA-Z0-9\$_]+';

  static List<NamedMode> get values => [anApple, AnApple, an_apple, AN_APPLE];

  static List<String> get names => [anApple.name, AnApple.name, an_apple.name, AN_APPLE.name];

  List<String> split(String input) {
    switch (this) {
      case an_apple:
      case AN_APPLE:
      case An_Apple:
        return input.split('_').toList();
      case anApple:
        var matches = RegExp('^($_LOWER_WORD)(($_FIRST_UPPER_WORD)*)\$').allMatches(input).first;
        String head = matches.group(1);
        String fullTail = matches.group(2);
        var allMatches2 = RegExp('($_FIRST_UPPER_WORD)').allMatches(fullTail);
        var tails = allMatches2.map((o) => o.group(1)).toList();
        return ([head]..addAll(tails)).toList();
      case AnApple:
        return RegExp('($_FIRST_UPPER_WORD)').allMatches(input).map((o) => o.group(1)).toList();
    }
    return [];
  }

  ///
  static const String _an_apple = '^($_ANY_WORD_BEGIN_NOT_NUMBER)(_$_ANY_WORD)*\$';
  static const an_apple = NamedMode._(_an_apple, 'an_apple', 50);

  ///
  static const String _AN_APPLE = '^($_UPPER_WORD)(_$_UPPER_WORD)*\$';
  static const AN_APPLE = NamedMode._(_AN_APPLE, 'AN_APPLE', 80);

  ///
  static const String _An_Apple = '^($_FIRST_UPPER_WORD)(_$_FIRST_UPPER_WORD*)*\$';
  static const An_Apple = NamedMode._(_An_Apple, 'An_Apple', 70);

  ///
  static const String _anApple = '^($_LOWER_WORD)($_FIRST_UPPER_WORD)*\$';
  static const anApple = NamedMode._(_anApple, 'anApple', 90);

  ///
  static const String _AnApple = '^($_FIRST_UPPER_WORD)+\$';
  static const AnApple = NamedMode._(_AnApple, 'AnApple', 100);

  ///
  static const String _unknown = '';
  static const unknown = NamedMode._(_unknown, 'unknown', 0);
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

String renameTo__An_Apple(String src) {
  return renameToOtherMode(src, NamedMode.An_Apple);
}

String renameTo__anApple(String src) {
  return renameToOtherMode(src, NamedMode.anApple);
}

String renameTo__AnApple(String src) {
  return renameToOtherMode(src, NamedMode.AnApple);
}

NamedMode resolveNamedMode(String src) {
  try {
    return NamedMode.values
        .where((m) => RegExp(m.value).hasMatch(src))
        .reduce((current, next) => current._priority > next._priority ? current : next);
  } catch (e) {
    return NamedMode.unknown;
  }
}

List<String> autoSplit(String src, {NamedMode parentNamedMode = NamedMode.unknown, bool recursive = true}) {
  NamedMode namedMode = resolveNamedMode(src);
  if (namedMode == parentNamedMode) return [src];
  if (namedMode == NamedMode.unknown) return [src];
  List<String> segments = namedMode.split(src);
  List<String> result = [];
  if (recursive) {
    for (String value in segments) {
      List<String> childSplits = autoSplit(value, parentNamedMode: parentNamedMode, recursive: recursive);
      result.addAll(childSplits);
    }
  } else {
    result.addAll(segments);
  }
  return result;
}

String combineWithNamedMode(List<String> segments, NamedMode mode) {
  if (segments.isEmpty) return null;
  switch (mode) {
    case NamedMode.an_apple:
      return segments.map((o) => replaceFirstChar(o, toUpper: false)).join('_');
    case NamedMode.AN_APPLE:
      return segments.map((o) => o.toUpperCase()).join('_');
    case NamedMode.An_Apple:
      return segments.map((o) => replaceFirstChar(o, toUpper: true)).join('_');
    case NamedMode.anApple:
      return segments.length == 1
          ? replaceFirstChar(segments[0], toUpper: false)
          : replaceFirstChar(segments[0], toUpper: false) +
              segments.skip(1).map((o) => replaceFirstChar(o, toUpper: true)).join('');
    case NamedMode.AnApple:
      return segments.length == 1
          ? replaceFirstChar(segments[0], toUpper: true)
          : replaceFirstChar(segments[0], toUpper: true) +
              segments.skip(1).map((o) => replaceFirstChar(o, toUpper: true)).join('');
  }
  return null;
}

String replaceFirstChar(String s, {bool toUpper = true}) {
  if (s == null || s.isEmpty) return '';
  if (s.length == 1) return toUpper ? s.toUpperCase() : s.toLowerCase();
  return (toUpper ? s.toUpperCase() : s.toLowerCase()).substring(0, 1) + s.substring(1);
}
