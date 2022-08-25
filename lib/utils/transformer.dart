class Transformer {
  String transformInt(String contents) {
    String result0 =
        contents.replaceAll("<int xmlns=\"http://tempuri.org/\">", "");

    String result1 =
        result0.replaceAll("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");

    String result = result1.replaceAll("</int>", "").trim();

    return result;
  }

  String transformString(String contents) {
    String result0 =
        contents.replaceAll("<string xmlns=\"http://tempuri.org/\">", "");

    String result1 =
        result0.replaceAll("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");

    String result = result1.replaceAll("</string>", "").trim();

    return result;
  }

  String convertToAgo(String input) {
    DateTime? date = DateTime.tryParse(input);
    Duration diff = DateTime.now().difference(date!);

    if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }
}
