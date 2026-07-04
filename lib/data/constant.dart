import 'package:flutter/material.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  MainPalette get mainColors => Theme.of(this).extension<MainPalette>()!;
  CardPalette get cardColors => Theme.of(this).extension<CardPalette>()!;
  StatusPalette get statusColors => Theme.of(this).extension<StatusPalette>()!;
}

class MainPalette extends ThemeExtension<MainPalette> {
  final Color primaryBg, cardBg, secondaryBg, activeBg, infoBg, primaryText, secondaryText, mutedText, infoText;

  MainPalette({required this.primaryBg, required this.cardBg, required this.secondaryBg, required this.activeBg, required this.infoBg, required this.primaryText, required this.secondaryText, required this.mutedText, required this.infoText});

  @override
  MainPalette copyWith({Color? primaryBg, cardBg, secondaryBg, activeBg, infoBg, primaryText, secondaryText, mutedText, infoText}) {
    return MainPalette(
      primaryBg: primaryBg ?? this.primaryBg,
      cardBg: cardBg ?? this.cardBg,
      secondaryBg: secondaryBg ?? this.secondaryBg,
      activeBg: activeBg ?? this.activeBg,
      infoBg: infoBg ?? this.infoBg,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      mutedText: mutedText ?? this.mutedText,
      infoText: infoText ?? this.infoText,
    );
  }

  @override

  MainPalette lerp(ThemeExtension<MainPalette>? other, double t){
    if (other is! MainPalette) return this;
    return MainPalette(
      primaryBg: Color.lerp(primaryBg, other.primaryBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      secondaryBg: Color.lerp(secondaryBg, other.secondaryBg, t)!,
      activeBg: Color.lerp(activeBg, other.activeBg, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      infoText: Color.lerp(infoText, other.infoText, t)!,
    );
  }
}

class CardPalette extends ThemeExtension<CardPalette> {
  final Color aqiLeftSide, aqiBorder, aqiGlow, coLeftSide, coBorder, coGlow, co2LeftSide, co2Border, co2Glow, tempLeftSide, tempBorder, tempGlow, humLeftSide, humBorder, humGlow, pressLeftSide, pressBorder, pressGlow, altiLeftSide, altiBorder, altiGlow;

  CardPalette({required this.aqiLeftSide, required this.aqiBorder, required this.aqiGlow, required this.coLeftSide, required this.coBorder, required this.coGlow, required this.co2LeftSide, required this.co2Border, required this.co2Glow, required this.tempLeftSide, required this.tempBorder, required this.tempGlow, required this.humLeftSide, required this.humBorder, required this.humGlow, required this.pressLeftSide, required this.pressBorder, required this.pressGlow, required this.altiLeftSide, required this.altiBorder, required this.altiGlow});

  @override
  CardPalette copyWith({Color? aqiLeftSide, aqiBorder, aqiGlow, coLeftSide, coBorder, coGlow, co2LeftSide, co2Border, co2Glow, tempLeftSide, tempBorder, tempGlow, humLeftSide, humBorder, humGlow, pressLeftSide, pressBorder, pressGlow, altiLeftSide, altiBorder, altiGlow}) {
    return CardPalette(
      aqiLeftSide: aqiLeftSide ?? this.aqiLeftSide,
      aqiBorder: aqiBorder ?? this.aqiBorder,
      aqiGlow: aqiGlow ??this.aqiGlow,
      coLeftSide: coLeftSide ?? this.coLeftSide,
      coBorder: coBorder ?? this.coBorder,
      coGlow: coGlow ?? this.coGlow,
      co2LeftSide: co2LeftSide ?? this.co2LeftSide,
      co2Border: co2Border ?? this.co2Border,
      co2Glow: co2Glow ?? this.co2Glow,
      tempLeftSide: tempLeftSide ?? this.tempLeftSide,
      tempBorder: tempBorder ?? this.tempBorder,
      tempGlow: tempGlow ?? this.tempGlow,
      humLeftSide: humLeftSide ?? this.humLeftSide,
      humBorder: humBorder ?? this.humBorder,
      humGlow: humGlow ?? this.humGlow,
      pressLeftSide: pressLeftSide ?? this.pressLeftSide,
      pressBorder: pressBorder ?? this.pressBorder,
      pressGlow: pressGlow ?? this.pressGlow,
      altiLeftSide: altiLeftSide ?? this.altiLeftSide,
      altiBorder: altiBorder ?? this.altiBorder,
      altiGlow: altiGlow ?? this.altiGlow
    );
  }

  @override
  CardPalette lerp(ThemeExtension<CardPalette>? other, double t) {
    if (other is! CardPalette) return this;
    return CardPalette(
      aqiLeftSide: Color.lerp(aqiLeftSide, other.aqiLeftSide, t)!,
      aqiBorder: Color.lerp(aqiBorder, other.aqiBorder, t)!,
      aqiGlow: Color.lerp(aqiGlow, other.aqiGlow, t)!,
      coLeftSide: Color.lerp(coLeftSide, other.coLeftSide, t)!,
      coBorder: Color.lerp(coBorder, other.coBorder, t)!,
      coGlow: Color.lerp(coGlow, other.coGlow, t)!,
      co2LeftSide: Color.lerp(co2LeftSide, other.co2LeftSide, t)!,
      co2Border: Color.lerp(co2Border, other.co2Border, t)!,
      co2Glow: Color.lerp(co2Glow, other.co2Glow, t)!,
      tempLeftSide: Color.lerp(tempLeftSide, other.tempLeftSide, t)!,
      tempBorder: Color.lerp(tempBorder, other.tempBorder, t)!,
      tempGlow: Color.lerp(tempGlow, other.tempGlow, t)!,
      humLeftSide: Color.lerp(humLeftSide, other.humLeftSide, t)!,
      humBorder: Color.lerp(humBorder, other.humBorder, t)!,
      humGlow: Color.lerp(humGlow, other.humGlow, t)!,
      pressLeftSide: Color.lerp(pressLeftSide, other.pressLeftSide, t)!,
      pressBorder: Color.lerp(pressBorder, other.pressBorder, t)!,
      pressGlow: Color.lerp(pressGlow, other.pressGlow, t)!,
      altiLeftSide: Color.lerp(altiLeftSide, other.altiLeftSide, t)!,
      altiBorder: Color.lerp(altiBorder, other.altiBorder, t)!,
      altiGlow: Color.lerp(altiGlow, other.altiGlow, t)!,
    );
  }
}

class StatusPalette extends ThemeExtension<StatusPalette> {
  final Color safeBg, safeText, warningBg, warningText, dangerBg, dangerText, connectBg, connectText, disconnectBg, disconnectText;

  StatusPalette({required this.safeBg, required this.safeText, required this.warningBg, required this.warningText, required this.dangerBg, required this.dangerText, required this.connectBg, required this.connectText, required this.disconnectBg, required this.disconnectText});

  @override
  StatusPalette copyWith({Color? safeBg, safeText, warningBg, warningText, dangerBg, dangerText, connectBg, connectText, disconnectBg, disconnectText}) {
    return StatusPalette(
      safeBg: safeBg ?? this.safeBg,
      safeText: safeText ?? this.safeText,
      warningBg: warningBg ?? this.warningBg,
      warningText: warningText ??this.warningText,
      dangerBg: dangerBg ?? this.dangerBg,
      dangerText: dangerText ?? this.dangerText,
      connectBg: connectBg ?? this.connectBg,
      connectText: connectText ?? this.connectText,
      disconnectBg: disconnectBg ?? this.disconnectBg,
      disconnectText: disconnectText ?? this.disconnectText,
    );
  }

  @override
  StatusPalette lerp(ThemeExtension<StatusPalette>? other, double t) {
    if (other is! StatusPalette) return this;
    return StatusPalette(
      safeBg: Color.lerp(safeBg, other.safeBg, t)!,
      safeText: Color.lerp(safeText, other.safeText, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
      dangerText: Color.lerp(dangerText, other.dangerText, t)!,
      connectBg: Color.lerp(connectBg, other.connectBg, t)!,
      connectText: Color.lerp(connectText, other.connectText, t)!,
      disconnectBg: Color.lerp(disconnectBg, other.disconnectBg, t)!,
      disconnectText: Color.lerp(disconnectText, other.disconnectText, t)!,
    );
  }
}

class AirGuardColors {
  // BACKGROUND COLORS Palette
  static Color primaryBgDark = Color(0xFF0F1117);
  static Color primaryBgLight = Color(0xFFF8F9FA);
  static Color cardBgDark = Color(0xFF1A1D27);
  static Color cardBgLight = Color(0xFFFFFFFF);
  static Color secondaryBgDark = Color(0xFF22263A);
  static Color secondaryBgLight = Color(0xFFF3F4F6);
  static Color activeBgDark = Color(0xFF1E3A5F);
  static Color activeBgLight = Color(0xFFEFF6FF);
  static Color infoBgDark = Color(0xFF3B82F6).withAlpha(38);
  static Color infoBgLight = Color(0xFF3B82F6).withAlpha(30);
  static Color gradientStart = Color(0xFF3B82F6);
  static Color gradientEnd = Color(0xFF8B5CF6);

  // TEXT COLORS Palette
  static Color primaryTextDark = Color(0xFFF1F5F9);
  static Color primaryTextLight = Color(0xFF1A1D25);
  static Color secondaryTextDark = Color(0xFF94A3B8);
  static Color secondaryTextLight = Color(0xFF6B7280);
  static Color mutedTextDark = Color(0xFF475569);
  static Color mutedTextLight = Color(0xFF94A3B8);
  static Color infoTextDark = Color(0xFF3B82F6);
  static Color infoTextLight = Color(0xFF1D4ED8);

  // READING COLORS Palette
  static Color aqi = Color(0xFF3B82F6);
  static Color aqiGlow = Color.fromARGB(90, 59, 130, 246);
  static Color co = Color(0xFFF59E0B);
  static Color coGlow = Color.fromARGB(90, 245, 158, 11);
  static Color co2 = Color(0xFFEF4444);
  static Color co2Glow = Color.fromARGB(90, 239, 68, 68);
  static Color temp = Color(0xFFF97316);
  static Color tempGlow = Color.fromARGB(90, 249, 115, 22);
  static Color hum = Color(0xFF22C55E);
  static Color humGlow = Color.fromARGB(90, 34, 197, 94);
  static Color press = Color(0xFF8B5CF6);
  static Color pressGlow = Color.fromARGB(90, 139, 92, 246);
  static Color alti = Color(0xFF14B8A6);
  static Color altiGlow = Color.fromARGB(90, 20, 184, 166);
  // STATUS COLORS Palette
  static Color safeTextDark = Color(0xFF22C55E);
  static Color safeTextLight = Color(0xFF15803D);
  static Color safeDark = Color(0xFF22C55E).withAlpha(38);
  static Color safeLight = Color(0xFF22C55E).withAlpha(30);
  static Color warningTextDark = Color(0xFFF59E0B);
  static Color warningTextLight = Color(0xFFB45309);
  static Color warningDark = Color(0xFFF59E0B).withAlpha(38);
  static Color warningLight = Color(0xFFF59E0B).withAlpha(30);
  static Color dangerTextDark = Color(0xFFEF4444);
  static Color dangerTextLight = Color(0xFFB91C1C);
  static Color dangerDark = Color(0xFFEF4444).withAlpha(38);
  static Color dangerLight = Color(0xFFEF4444).withAlpha(30);

  // CONNECT COLORS Palette
  static Color connectTextDark = Color(0xFF10B981);
  static Color connectTextLight = Color(0xFF047857);
  static Color connectDark = Color(0xFF10B981).withAlpha(38);
  static Color connectLight = Color(0xFF10B981).withAlpha(30);
  static Color disconnectTextDark = Color(0xFF94A3B8);
  static Color disconnectTextLight = Color(0xFF475569);
  static Color disconnectDark = Color(0xFFEF4444).withAlpha(38);
  static Color disconnectLight = Color(0xFFEF4444).withAlpha(30);
}

ThemeData lightScheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: AirGuardColors.primaryBgLight),
  extensions: [
    MainPalette(
      primaryBg: AirGuardColors.primaryBgLight,
      cardBg: AirGuardColors.cardBgLight,
      secondaryBg: AirGuardColors.secondaryBgLight,
      activeBg: AirGuardColors.activeBgLight,
      infoBg: AirGuardColors.infoBgLight,
      primaryText: AirGuardColors.primaryTextLight,
      secondaryText: AirGuardColors.secondaryTextLight,
      mutedText: AirGuardColors.mutedTextLight,
      infoText: AirGuardColors.infoTextLight,
    ),
    StatusPalette(
      safeBg: AirGuardColors.safeLight,   
      safeText: AirGuardColors.safeTextLight,
      warningBg: AirGuardColors.warningLight,
      warningText: AirGuardColors.warningTextLight,
      dangerBg: AirGuardColors.dangerLight,
      dangerText: AirGuardColors.dangerTextLight,
      connectBg: AirGuardColors.connectLight,
      connectText: AirGuardColors.connectTextLight,
      disconnectBg: AirGuardColors.disconnectLight,
      disconnectText: AirGuardColors.disconnectTextLight,
    ),
    CardPalette(
      aqiLeftSide: AirGuardColors.aqi,
      aqiBorder: AirGuardColors.aqi,
      aqiGlow: AirGuardColors.aqiGlow,
      coLeftSide: AirGuardColors.co,
      coBorder: AirGuardColors.co,
      coGlow:AirGuardColors.coGlow,
      co2LeftSide: AirGuardColors.co2,
      co2Border: AirGuardColors.co2,
      co2Glow: AirGuardColors.co2Glow,
      tempLeftSide: AirGuardColors.temp,
      tempBorder: AirGuardColors.temp,
      tempGlow: AirGuardColors.tempGlow,
      humLeftSide: AirGuardColors.hum,
      humBorder: AirGuardColors.hum,
      humGlow: AirGuardColors.humGlow,
      pressLeftSide: AirGuardColors.press,
      pressBorder: AirGuardColors.press,
      pressGlow: AirGuardColors.pressGlow,
      altiLeftSide: AirGuardColors.alti,
      altiBorder: AirGuardColors.alti,
      altiGlow: AirGuardColors.altiGlow,
    ),
  ],
);

ThemeData darkScheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: AirGuardColors.primaryBgDark, brightness: Brightness.dark),
  extensions: [
    MainPalette(
      primaryBg: AirGuardColors.primaryBgDark,
      cardBg: AirGuardColors.cardBgDark,
      secondaryBg: AirGuardColors.secondaryBgDark,
      activeBg: AirGuardColors.activeBgDark,
      infoBg: AirGuardColors.infoBgDark,
      primaryText: AirGuardColors.primaryTextDark,
      secondaryText: AirGuardColors.secondaryTextDark,
      mutedText: AirGuardColors.mutedTextDark,
      infoText: AirGuardColors.infoTextDark,
    ),
    StatusPalette(
      safeBg: AirGuardColors.safeDark,
      safeText: AirGuardColors.safeTextDark,
      warningBg: AirGuardColors.warningDark,
      warningText: AirGuardColors.warningTextDark,
      dangerBg: AirGuardColors.dangerDark,
      dangerText: AirGuardColors.dangerTextDark,
      connectBg: AirGuardColors.connectDark,
      connectText: AirGuardColors.connectTextDark,
      disconnectBg: AirGuardColors.disconnectDark,
      disconnectText: AirGuardColors.disconnectTextDark,
    ),
    CardPalette(
      aqiLeftSide: AirGuardColors.aqi,
      aqiBorder: AirGuardColors.aqi,
      aqiGlow: AirGuardColors.aqiGlow,
      coLeftSide: AirGuardColors.co,
      coBorder:AirGuardColors.co,
      coGlow: AirGuardColors.coGlow,
      co2LeftSide: AirGuardColors.co2,
      co2Border: AirGuardColors.co2,
      co2Glow: AirGuardColors.co2Glow,
      tempLeftSide: AirGuardColors.temp,
      tempBorder: AirGuardColors.temp,
      tempGlow: AirGuardColors.tempGlow,
      humLeftSide: AirGuardColors.hum,
      humBorder: AirGuardColors.hum,
      humGlow: AirGuardColors.humGlow,
      pressLeftSide: AirGuardColors.press,
      pressBorder: AirGuardColors.press,
      pressGlow: AirGuardColors.pressGlow,
      altiLeftSide: AirGuardColors.alti,
      altiBorder: AirGuardColors.alti,
      altiGlow: AirGuardColors.altiGlow,
    ),
  ],
);