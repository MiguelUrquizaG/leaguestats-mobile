import 'dart:convert';

dynamic safeJsonDecode(String rawBody) {
  final sanitized = rawBody.trim().replaceFirst('\uFEFF', '');
  final repaired = _repairCommonIssues(sanitized);

  try {
    return jsonDecode(sanitized);
  } on FormatException {
    try {
      return jsonDecode(repaired);
    } on FormatException {
      final extracted = _extractFirstJsonPayload(repaired);
      if (extracted == null) {
        rethrow;
      }

      return jsonDecode(extracted);
    }
  }
}

List<Map<String, dynamic>> safeExtractJsonObjects(String rawBody) {
  final sanitized = _repairCommonIssues(
    rawBody.trim().replaceFirst('\uFEFF', ''),
  );
  final objects = <Map<String, dynamic>>[];

  final fragments = _extractTopLevelJsonObjects(sanitized);

  for (final fragment in fragments) {
    try {
      final decoded = jsonDecode(fragment);
      if (decoded is Map<String, dynamic>) {
        objects.add(decoded);
      }
    } catch (_) {
      continue;
    }
  }

  return objects;
}

String _repairCommonIssues(String input) {
  var output = input;

  output = output.replaceAllMapped(
    RegExp(r':\s*"{3,}(?=\s*[,}])'),
    (_) => ':""',
  );

  output = output.replaceAllMapped(
    RegExp(r'}\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*:'),
    (match) => '},"${match.group(1)}":',
  );

  output = output.replaceAllMapped(
    RegExp(r']\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*:'),
    (match) => '],"${match.group(1)}":',
  );

  output = output.replaceAllMapped(
    RegExp(r'"\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*:'),
    (match) => '","${match.group(1)}":',
  );

  output = output.replaceAll(RegExp(r',\s*([}\]])'), r'$1');

  return output;
}

String? _extractFirstJsonPayload(String input) {
  final objectStart = input.indexOf('{');
  final listStart = input.indexOf('[');

  int start = -1;

  if (objectStart == -1) {
    start = listStart;
  } else if (listStart == -1) {
    start = objectStart;
  } else {
    start = objectStart < listStart ? objectStart : listStart;
  }

  if (start == -1) {
    return null;
  }

  final opening = input[start];
  final closing = opening == '{' ? '}' : ']';

  var depth = 0;
  var inString = false;
  var isEscaped = false;

  for (var i = start; i < input.length; i++) {
    final char = input[i];

    if (inString) {
      if (isEscaped) {
        isEscaped = false;
        continue;
      }

      if (char == '\\') {
        isEscaped = true;
        continue;
      }

      if (char == '"') {
        inString = false;
      }

      continue;
    }

    if (char == '"') {
      inString = true;
      continue;
    }

    if (char == opening) {
      depth++;
      continue;
    }

    if (char == closing) {
      depth--;
      if (depth == 0) {
        return input.substring(start, i + 1);
      }
    }
  }

  return null;
}

List<String> _extractTopLevelJsonObjects(String input) {
  final objects = <String>[];

  var depth = 0;
  var inString = false;
  var isEscaped = false;
  var startIndex = -1;

  for (var i = 0; i < input.length; i++) {
    final char = input[i];

    if (inString) {
      if (isEscaped) {
        isEscaped = false;
        continue;
      }

      if (char == '\\') {
        isEscaped = true;
        continue;
      }

      if (char == '"') {
        inString = false;
      }

      continue;
    }

    if (char == '"') {
      inString = true;
      continue;
    }

    if (char == '{') {
      if (depth == 0) {
        startIndex = i;
      }
      depth++;
      continue;
    }

    if (char == '}') {
      if (depth == 0) {
        continue;
      }

      depth--;
      if (depth == 0 && startIndex != -1) {
        objects.add(input.substring(startIndex, i + 1));
        startIndex = -1;
      }
    }
  }

  return objects;
}
