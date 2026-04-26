import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/l10n/car_translations.dart';

class AddPostFeaturesScreen extends StatelessWidget {
  const AddPostFeaturesScreen({super.key});

  static const Map<String, String> featureLabels = {
    // Safety
    'abs': 'ABS',
    'traction_control': 'Traction Control',
    'tire_pressure_monitoring_system': 'Tire Pressure',
    'lane_departure_warning': 'Lane Departure',
    'automatic_emergency_braking': 'Auto Braking',
    'blind_spot_monitoring': 'Blind Spot',
    'adaptive_cruise_control': 'Cruise Control',
    // Parking & Visibility
    'rear_parking_sensors': 'Parking Sensors',
    'rearview_camera': 'Rear Camera',
    'fog_lights': 'Fog Lights',
    'led_headlights': 'LED Headlights',
    'automatic_headlights': 'Auto Headlights',
    'rain_sensing_wipers': 'Rain Wipers',
    // Comfort & Convenience
    'panoramic_sunroof': 'Panoramic Roof',
    'adaptive_climate_control': 'Climate Control',
    'power_windows': 'Power Windows',
    'power_mirrors': 'Power Mirrors',
    'heated_seats': 'Heated Seats',
    'ventilated_seats': 'Ventilated Seats',
    'keyless_entry': 'Keyless Entry',
    'push_button_start': 'Push Start',
    'electric_parking_brake': 'Electric Brake',
    'memory_electronic_adjustable_seats': 'Memory Seats',
    'rear_ac_vents': 'Rear AC Vents',
    // Technology
    'touchscreen_display': 'Touchscreen',
    'bluetooth_connectivity': 'Bluetooth',
    'apple_carplay': 'Apple CarPlay',
    'android_auto': 'Android Auto',
    'usb_type_c_ports': 'USB-C Ports',
    'navigation_system_gps': 'Navigation',
    'voice_control': 'Voice Control',
    'wireless_charging': 'Wireless Charging',
    'premium_sound_system': 'Premium Sound',
    'drive_modes': 'Drive Modes',
  };

  static const Map<String, IconData> featureIcons = {
    // Safety
    'abs': Icons.car_crash,
    'traction_control': Icons.settings,
    'tire_pressure_monitoring_system': Icons.tire_repair,
    'lane_departure_warning': Icons.swap_horiz,
    'automatic_emergency_braking': Icons.emergency,
    'blind_spot_monitoring': Icons.visibility,
    'adaptive_cruise_control': Icons.speed,
    // Parking & Visibility
    'rear_parking_sensors': Icons.sensors,
    'rearview_camera': Icons.videocam,
    'fog_lights': Icons.wb_twilight,
    'led_headlights': Icons.light,
    'automatic_headlights': Icons.nightlight,
    'rain_sensing_wipers': Icons.water_drop,
    // Comfort & Convenience
    'panoramic_sunroof': Icons.window,
    'adaptive_climate_control': Icons.ac_unit,
    'power_windows': Icons.roller_shades,
    'power_mirrors': Icons.compare,
    'heated_seats': Icons.event_seat,
    'ventilated_seats': Icons.air,
    'keyless_entry': Icons.vpn_key,
    'push_button_start': Icons.radio_button_checked,
    'electric_parking_brake': Icons.local_parking,
    'memory_electronic_adjustable_seats': Icons.chair,
    'rear_ac_vents': Icons.hvac,
    // Technology
    'touchscreen_display': Icons.touch_app,
    'bluetooth_connectivity': Icons.bluetooth,
    'apple_carplay': Icons.play_circle_outline,
    'android_auto': Icons.android,
    'usb_type_c_ports': Icons.usb,
    'navigation_system_gps': Icons.navigation,
    'voice_control': Icons.mic,
    'wireless_charging': Icons.wifi_tethering,
    'premium_sound_system': Icons.speaker,
    'drive_modes': Icons.tune,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final create = context.watch<CreateCarProvider>();
    final features = create.draft.features;

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== App Bar =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    _circleButton(
                      context: context,
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    Text(
                      l.question1of5,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 1 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066EE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.step2,
              style: const TextStyle(
                color: Color(0xFF0066EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.whatFeaturesAvailable,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              l.selectFeaturesDescription,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // ===== GRID =====
            Expanded(
              child: GridView.builder(
                itemCount: featureLabels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, i) {
                  final key = featureLabels.keys.elementAt(i);
                  final label = CarTranslations.getFeatureLabel(key, l);
                  final isSelected = features[key] == true;

                  return GestureDetector(
                    onTap: () => create.toggleFeature(key),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF1FF)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0066EE)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            featureIcons[key] ?? Icons.help_outline,
                            size: 26,
                            color: isSelected
                                ? const Color(0xFF0066EE)
                                : Colors.black54,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF0066EE)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/colors'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  l.continueBtn,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

}
