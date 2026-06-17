class SafeParser {
  static int parseInt(Map<String, dynamic> json, String key, {int defaultValue = 0}) {
    if (json[key] == null) return defaultValue;
    if (json[key] is int) return json[key] as int;
    if (json[key] is num) return (json[key] as num).toInt();
    if (json[key] is String) {
      return int.tryParse(json[key] as String) ?? defaultValue;
    }
    return defaultValue;
  }
  
  static int? parseIntNullable(Map<String, dynamic> json, String key) {
    if (json[key] == null) return null;
    if (json[key] is int) return json[key] as int;
    if (json[key] is num) return (json[key] as num).toInt();
    if (json[key] is String) {
      return int.tryParse(json[key] as String);
    }
    return null;
  }

  static double parseDouble(Map<String, dynamic> json, String key, {double defaultValue = 0.0}) {
    if (json[key] == null) return defaultValue;
    if (json[key] is double) return json[key] as double;
    if (json[key] is num) return (json[key] as num).toDouble();
    if (json[key] is String) {
      return double.tryParse(json[key] as String) ?? defaultValue;
    }
    return defaultValue;
  }
  
  static double? parseDoubleNullable(Map<String, dynamic> json, String key) {
    if (json[key] == null) return null;
    if (json[key] is double) return json[key] as double;
    if (json[key] is num) return (json[key] as num).toDouble();
    if (json[key] is String) {
      return double.tryParse(json[key] as String);
    }
    return null;
  }

  static String parseString(Map<String, dynamic> json, String key, {String defaultValue = ''}) {
    if (json[key] == null) return defaultValue;
    if (json[key] is String) return json[key] as String;
    return json[key].toString();
  }
  
  static String? parseStringNullable(Map<String, dynamic> json, String key) {
    if (json[key] == null) return null;
    if (json[key] is String) return json[key] as String;
    return json[key].toString();
  }

  static bool parseBool(Map<String, dynamic> json, String key, {bool defaultValue = false}) {
    if (json[key] == null) return defaultValue;
    if (json[key] is bool) return json[key] as bool;
    if (json[key] is String) {
      return json[key].toString().toLowerCase() == 'true' || json[key] == '1';
    }
    if (json[key] is num) {
      return json[key] == 1;
    }
    return defaultValue;
  }

  static bool? parseBoolNullable(Map<String, dynamic> json, String key) {
    if (json[key] == null) return null;
    if (json[key] is bool) return json[key] as bool;
    if (json[key] is String) {
      return json[key].toString().toLowerCase() == 'true' || json[key] == '1';
    }
    if (json[key] is num) {
      return json[key] == 1;
    }
    return null;
  }

  /// Extrayendo IDs resolviendo rutas anidadas, ej. 'empresa_auditora.id_empresa'
  static int parseIntFromMultiplePaths(Map<String, dynamic> json, List<String> paths, {int defaultValue = 0}) {
    for (String path in paths) {
      final parts = path.split('.');
      dynamic current = json;
      bool found = true;
      
      for (String part in parts) {
        if (current is Map<String, dynamic> && current.containsKey(part)) {
          current = current[part];
        } else {
          found = false;
          break;
        }
      }
      
      if (found && current != null) {
        if (current is int) return current;
        if (current is num) return current.toInt();
        if (current is String) {
          final parsed = int.tryParse(current);
          if (parsed != null) return parsed;
        }
      }
    }
    return defaultValue;
  }
}
