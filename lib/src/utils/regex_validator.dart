class RegexValidator {
  final String regexSource;

  const RegexValidator({required this.regexSource});

  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (error) {
      assert(false, error.toString());
      return true;
    }
  }
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator()
      : super(
      regexSource: r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      // regexSource: "(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]+\$)");
}

class UsernameSubmitRegexValidator extends RegexValidator {
  UsernameSubmitRegexValidator()
      : super(
      regexSource: "(a-zA-Z0-9)");
}