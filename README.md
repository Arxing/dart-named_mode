## Usage

A simple usage example:

```dart
import 'package:named_mode/named_mode.dart';

main() {
  NamedMode namedMode;

  /// you can get named mode of string
  String s1 = 'HelloWorld';
  namedMode = resolveNamedMode(s1);
  print(namedMode.name); // NamedMode.AnApple
  namedMode = NamedMode.parseOn(s1);
  print(namedMode.name); // NamedMode.AnApple

  String s2 = 'hello_world';
  namedMode = resolveNamedMode(s2);
  print(namedMode.name); // NamedMode.an_apple

  /// you will get unknown when parse incorrect format string
  String s3 = 'apple_Pie';
  namedMode = resolveNamedMode(s3);
  print(namedMode.name); // NameMode.unknown

  /// you can use simple function to translate names.
  print(renameTo__AN_APPLE(s1)); // HELLO_WORLD
  print(renameTo__An_Apple(s1)); // Hello_World
  print(renameTo__an_apple(s1)); // hello_world
  print(renameTo__AnApple(s1)); // HelloWorld
  print(renameTo__anApple(s1)); // helloWorld
  /// or select mode yourself
  print(renameToOtherMode(s1, NamedMode.anApple)); // helloWorld

  /// replace first char to upper/lower case
  print(replaceFirstChar('apple', toUpper: true)); // Apple
  print(replaceFirstChar('Banana', toUpper: false)); // banana

  /// split string by specific named mode
  var result = NamedMode.an_apple.split('this_is_a_book');
  print(result); // [this, is, a, book]
  result = NamedMode.anApple.split('thisIsABook');
  print(result); // [this, is, a, book]
  result = NamedMode.an_apple.split('thisIsABook');
  print(result); // [thisisabook]

  /// combine segments to specific named mode string
  var segments = ['this', 'is', 'a', 'book'];
  print(combineWithNamedMode(segments, NamedMode.an_apple)); // this_is_a_book
  print(combineWithNamedMode(segments, NamedMode.AN_APPLE)); // THIS_IS_A_BOOK
  print(combineWithNamedMode(segments, NamedMode.An_Apple)); // This_Is_A_Book
  print(combineWithNamedMode(segments, NamedMode.anApple)); // thisIsABook
  print(combineWithNamedMode(segments, NamedMode.AnApple)); // ThisIsABook
}

```

## Features and bugs

Now support five named mode:
+ an_apple
+ AN_APPLE
+ An_Apple
+ anApple
+ AnApple
