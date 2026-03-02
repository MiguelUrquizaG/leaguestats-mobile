import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class SettingsService {
  final String _apiUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = StorageService();

  Future<double> getPremiumMultiplier() async {
    final token = await _storageService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$_apiUrl/settings'),
      headers: headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error loading settings: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final multiplier = _extractPremiumMultiplier(decoded);

    if (multiplier == null || multiplier <= 0) {
      throw Exception('Premium multiplier not found in settings endpoint');
    }

    return multiplier;
  }

  double? _extractPremiumMultiplier(dynamic data) {
    const directKeys = [
      'premium_multiplier',
      'premiumMultiplier',
      'bet_premium_multiplier',
      'bets_premium_multiplier',
      'multiplier',
    ];

    if (data is num) return data.toDouble();

    if (data is String) {
      final parsed = double.tryParse(data);
      return parsed;
    }

    if (data is Map<String, dynamic>) {
      for (final key in directKeys) {
        if (data.containsKey(key)) {
          final parsed = _extractPremiumMultiplier(data[key]);
          if (parsed != null) return parsed;
        }
      }

      for (final entry in data.entries) {
        final keyLower = entry.key.toLowerCase();
        if (keyLower.contains('premium') && keyLower.contains('multiplier')) {
          final parsed = _extractPremiumMultiplier(entry.value);
          if (parsed != null) return parsed;
        }
      }

      if (data.containsKey('settings')) {
        final parsed = _extractPremiumMultiplier(data['settings']);
        if (parsed != null) return parsed;
      }

      if (data.containsKey('data')) {
        final parsed = _extractPremiumMultiplier(data['data']);
        if (parsed != null) return parsed;
      }

      if (data.containsKey('value')) {
        final parsed = _extractPremiumMultiplier(data['value']);
        if (parsed != null) return parsed;
      }
    }

    if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          final key = (item['key'] ?? item['name'] ?? item['slug'])
              ?.toString()
              .toLowerCase();
          final value = item['value'] ?? item['setting_value'] ?? item['data'];
          if (key != null && key.contains('premium') && key.contains('multiplier')) {
            final parsed = _extractPremiumMultiplier(value);
            if (parsed != null) return parsed;
          }
        }

        final parsed = _extractPremiumMultiplier(item);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }
}
