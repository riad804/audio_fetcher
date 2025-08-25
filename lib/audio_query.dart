import 'dart:convert';
import 'package:flutter/material.dart';

import 'audio_item_model.dart';
import 'audio_query_platform_interface.dart';

class AudioQuery {
  Future<List<AudioItemModel>> getAudios() {
    return AudioQueryPlatform.instance.getSongs();
  }

  Image songImage(String? base64) {
    if (base64 == null || base64.isEmpty) {
      return Image.asset("assets/images/no_image_view.png");
    }
    return Image.memory(base64Decode(base64));
  }
}
