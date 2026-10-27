import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SpacingExtension on num {
  SizedBox get verticalSpacing => SizedBox(height: h);
  SizedBox get horizontalSpacing => SizedBox(width: w);
}
