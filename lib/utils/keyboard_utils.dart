import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardUtils {
  // 强制显示键盘
  static void forceShowKeyboard(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }
  
  // 隐藏键盘
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
} 