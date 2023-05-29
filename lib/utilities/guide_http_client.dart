import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/guide.dart';

class GuideHTTPClient {
    static final env = dotenv.env;
    static final Map<String, String> headers = {
      'accept': 'application/json',
      'CONJURE-API-APPLICATION-ID': env['CONJURE_API_APPLICATION_ID'] ?? '',
      'CONJURE-API-ACCESS-TOKEN': env['CONJURE_API_ACCESS_TOKEN'] ?? '',
    };

    final String guideTitle;
    const GuideHTTPClient({required this.guideTitle});

    // Helper function to check if guide exists
    Future<bool> guideExists() async {
      final response = await http.get(
        Uri.parse('${env['CONJURE_API_URL']}/how-to/exists?task=$guideTitle'),
        headers: headers
      );
      return response.statusCode == 200;
    }

    // Helper function to fetch guide
    Future<Guide?> fetchGuide() async {
      final response = await http.get(
        Uri.parse('${env['CONJURE_API_URL']}/how-to?task=$guideTitle'),
        headers: headers
      );
      return response.statusCode == 200 ? Guide.fromJson(jsonDecode(response.body)) : null;
    }
}
