import 'package:sayarti/l10n/app_localizations.dart';

/// Utility for translating car-related values — both feature keys and
/// fixed backend-returned strings (fuel type, body style, transmission, etc.).
class CarTranslations {
  // ── Feature labels ────────────────────────────────────────────────────────

  static String getFeatureLabel(String key, AppLocalizations l) {
    final map = {
      'abs': l.featureAbs,
      'traction_control': l.featureTractionControl,
      'tire_pressure_monitoring_system': l.featureTirePressure,
      'lane_departure_warning': l.featureLaneDeparture,
      'automatic_emergency_braking': l.featureAutoBraking,
      'blind_spot_monitoring': l.featureBlindSpot,
      'adaptive_cruise_control': l.featureCruiseControl,
      'rear_parking_sensors': l.featureParkingSensors,
      'rearview_camera': l.featureRearCamera,
      'fog_lights': l.featureFogLights,
      'led_headlights': l.featureLedHeadlights,
      'automatic_headlights': l.featureAutoHeadlights,
      'rain_sensing_wipers': l.featureRainWipers,
      'panoramic_sunroof': l.featurePanoramicRoof,
      'adaptive_climate_control': l.featureClimateControl,
      'power_windows': l.featurePowerWindows,
      'power_mirrors': l.featurePowerMirrors,
      'heated_seats': l.featureHeatedSeats,
      'ventilated_seats': l.featureVentilatedSeats,
      'keyless_entry': l.featureKeylessEntry,
      'push_button_start': l.featurePushStart,
      'electric_parking_brake': l.featureElectricBrake,
      'memory_electronic_adjustable_seats': l.featureMemorySeats,
      'rear_ac_vents': l.featureRearAcVents,
      'touchscreen_display': l.featureTouchscreen,
      'bluetooth_connectivity': l.featureBluetooth,
      'apple_carplay': l.featureAppleCarplay,
      'android_auto': l.featureAndroidAuto,
      'usb_type_c_ports': l.featureUsbPorts,
      'navigation_system_gps': l.featureNavigation,
      'voice_control': l.featureVoiceControl,
      'wireless_charging': l.featureWirelessCharging,
      'premium_sound_system': l.featurePremiumSound,
      'drive_modes': l.featureDriveModes,
    };
    return map[key] ?? key;
  }

  // ── Backend value translation ─────────────────────────────────────────────
  // Translates fixed known backend strings (fuel type, transmission, etc.)
  // Returns the original value unchanged when locale is English.

  static String translateValue(String value, AppLocalizations l) {
    if (l.localeName != 'ar') return value;
    const arMap = <String, String>{
      // Fuel types
      'Gasoline': 'بنزين',
      'Petrol': 'بنزين',
      'Diesel': 'ديزل',
      'Electric': 'كهربائي',
      'Hybrid': 'هجين',
      'Plug-in Hybrid': 'هجين قابل للشحن',
      'LPG': 'غاز',
      // Transmission
      'Automatic': 'أوتوماتيك',
      'Manual': 'يدوي',
      'CVT': 'CVT',
      'Semi-Automatic': 'نصف أوتوماتيك',
      // Drive train
      'FWD': 'دفع أمامي',
      'RWD': 'دفع خلفي',
      'AWD': 'دفع رباعي',
      '4WD': 'دفع رباعي كامل',
      '4x4': 'دفع رباعي',
      // Body styles
      'Sedan': 'سيدان',
      'SUV': 'إس يو في',
      'Hatchback': 'هاتشباك',
      'Pickup': 'بيكب',
      'Pickup Truck': 'بيكب',
      'Coupe': 'كوبيه',
      'Convertible': 'كشف',
      'Van': 'فان',
      'Wagon': 'ستيشن',
      'Station Wagon': 'ستيشن',
      'Crossover': 'كروس أوفر',
      'Minivan': 'ميني فان',
      'Truck': 'شاحنة',
      'Sport': 'رياضي',
      // Colors
      'White': 'أبيض',
      'Black': 'أسود',
      'Silver': 'فضي',
      'Gray': 'رمادي',
      'Grey': 'رمادي',
      'Red': 'أحمر',
      'Blue': 'أزرق',
      'Brown': 'بني',
      'Beige': 'بيج',
      'Green': 'أخضر',
      'Yellow': 'أصفر',
      'Orange': 'برتقالي',
      'Gold': 'ذهبي',
      'Pink': 'وردي',
      'Purple': 'بنفسجي',
      'Navy': 'كحلي',
      'Maroon': 'عنابي',
      'Champagne': 'شمباني',
      'Pearl': 'لؤلؤي',
    };
    return arMap[value] ?? value;
  }
}
