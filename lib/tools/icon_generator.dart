import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ws_vpn/widgets/common/custom_vpn_icon_painter.dart';

/// 此工具类用于生成应用图标
/// 需要在命令行手动运行这个文件来生成图标
class IconGenerator {
  static Future<void> generateIcons() async {
    // 创建不同尺寸的图标
    await _generateIcon(1024, 'vpn_icon.png');
    await _generateIcon(1024, 'vpn_icon_foreground.png', backgroundTransparent: true);
    
    print('图标生成完成！');
    print('现在你可以运行: flutter pub run flutter_launcher_icons');
  }
  
  static Future<void> _generateIcon(double size, String filename, {bool backgroundTransparent = false}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final painter = VpnIconPainter(
      paintBackground: !backgroundTransparent,
      backgroundColor: const Color(0xFF4A80F0),
      shieldColor: const Color(0xFF4A80F0),
      shieldStrokeColor: Colors.white,
      lightningColor: Colors.white,
    );
    
    painter.paint(canvas, Size(size, size));
    
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData != null) {
      final buffer = byteData.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final iconDir = Directory('${directory.path}/assets/icons');
      
      if (!await iconDir.exists()) {
        await iconDir.create(recursive: true);
      }
      
      final file = File('${iconDir.path}/$filename');
      await file.writeAsBytes(buffer);
      
      print('生成图标: ${file.path}');
    } else {
      print('无法生成图标数据');
    }
  }
}

// 为了在命令行运行此文件
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IconGenerator.generateIcons();
} 