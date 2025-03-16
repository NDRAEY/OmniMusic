import 'package:flutter/material.dart';

enum RepeatMode {
  none,
  all,
  one,
}

RepeatMode switchRepeatMode(RepeatMode mode) {
  if (mode == RepeatMode.all) {
    return RepeatMode.one;
  } else if (mode == RepeatMode.one) {
    return RepeatMode.none;
  } else {
    return RepeatMode.all;
  }
}

IconData repeatModeToIcon(RepeatMode mode) {
  if (mode == RepeatMode.none) {
    return Icons.repeat;
  } else if (mode == RepeatMode.all) {
    return Icons.repeat_on_outlined;
  } else {
    return Icons.repeat_one_on_outlined;
  }
}