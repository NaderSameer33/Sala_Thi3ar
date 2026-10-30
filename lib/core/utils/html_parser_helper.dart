abstract class HtmlParserHelper {
  static String parseHtmlString(String htmlString) {
    if (htmlString.isEmpty) return '';
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString
        .replaceAll(exp, '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\n\s*\n'), '\n\n')
        .trim();
  }
}

