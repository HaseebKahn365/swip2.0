import 'package:flutter/material.dart';

/// Consistent spacing values throughout the app
class AppSpacing {
  // Base spacing unit (4px)
  static const double unit = 4.0;
  
  // Spacing scale
  static const double xs = unit;           // 4px
  static const double sm = unit * 2;       // 8px
  static const double md = unit * 3;       // 12px
  static const double lg = unit * 4;       // 16px
  static const double xl = unit * 5;       // 20px
  static const double xxl = unit * 6;      // 24px
  static const double xxxl = unit * 8;     // 32px
  
  // Common padding values
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  
  // Horizontal padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(horizontal: xxl);
  
  // Vertical padding
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(vertical: xxl);
  
  // Common margin values
  static const EdgeInsets marginXS = EdgeInsets.all(xs);
  static const EdgeInsets marginSM = EdgeInsets.all(sm);
  static const EdgeInsets marginMD = EdgeInsets.all(md);
  static const EdgeInsets marginLG = EdgeInsets.all(lg);
  static const EdgeInsets marginXL = EdgeInsets.all(xl);
  static const EdgeInsets marginXXL = EdgeInsets.all(xxl);
  
  // SizedBox helpers
  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapSM = SizedBox(width: sm, height: sm);
  static const SizedBox gapMD = SizedBox(width: md, height: md);
  static const SizedBox gapLG = SizedBox(width: lg, height: lg);
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);
  static const SizedBox gapXXL = SizedBox(width: xxl, height: xxl);
  
  // Horizontal gaps
  static const SizedBox gapHorizontalXS = SizedBox(width: xs);
  static const SizedBox gapHorizontalSM = SizedBox(width: sm);
  static const SizedBox gapHorizontalMD = SizedBox(width: md);
  static const SizedBox gapHorizontalLG = SizedBox(width: lg);
  static const SizedBox gapHorizontalXL = SizedBox(width: xl);
  static const SizedBox gapHorizontalXXL = SizedBox(width: xxl);
  
  // Vertical gaps
  static const SizedBox gapVerticalXS = SizedBox(height: xs);
  static const SizedBox gapVerticalSM = SizedBox(height: sm);
  static const SizedBox gapVerticalMD = SizedBox(height: md);
  static const SizedBox gapVerticalLG = SizedBox(height: lg);
  static const SizedBox gapVerticalXL = SizedBox(height: xl);
  static const SizedBox gapVerticalXXL = SizedBox(height: xxl);
  
  // Border radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 6.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusFull = 9999.0;
  
  // BorderRadius helpers
  static BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);
  static BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);
  static BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);
  static BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);
  static BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);
  
  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;
  
  // Button heights
  static const double buttonHeightSM = 32.0;
  static const double buttonHeightMD = 40.0;
  static const double buttonHeightLG = 48.0;
  
  // Input heights
  static const double inputHeightSM = 36.0;
  static const double inputHeightMD = 44.0;
  static const double inputHeightLG = 52.0;
}
