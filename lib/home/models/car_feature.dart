// car_feature.dart

class CarFeature {
  final bool abs;
  final bool panoramicSunroof;
  final bool tractionControl;
  final bool tirePressureMonitoringSystem;
  final bool rearParkingSensors;
  final bool rearviewCamera;
  final bool laneDepartureWarning;
  final bool automaticEmergencyBraking;
  final bool blindSpotMonitoring;
  final bool adaptiveCruiseControl;
  final bool adaptiveClimateControl;
  final bool powerWindows;
  final bool powerMirrors;
  final bool heatedSeats;
  final bool ventilatedSeats;
  final bool keylessEntry;
  final bool pushButtonStart;
  final bool electricParkingBrake;
  final bool memoryElectronicAdjustableSeats;
  final bool rearAcVents;
  final bool touchscreenDisplay;
  final bool bluetoothConnectivity;
  final bool appleCarplay;
  final bool androidAuto;
  final bool usbTypeCPorts;
  final bool navigationSystemGps;
  final bool voiceControl;
  final bool wirelessCharging;
  final bool premiumSoundSystem;
  final bool ledHeadlights;
  final bool fogLights;
  final bool automaticHeadlights;
  final bool rainSensingWipers;
  final bool driveModes;

  CarFeature({
    required this.abs,
    required this.panoramicSunroof,
    required this.tractionControl,
    required this.tirePressureMonitoringSystem,
    required this.rearParkingSensors,
    required this.rearviewCamera,
    required this.laneDepartureWarning,
    required this.automaticEmergencyBraking,
    required this.blindSpotMonitoring,
    required this.adaptiveCruiseControl,
    required this.adaptiveClimateControl,
    required this.powerWindows,
    required this.powerMirrors,
    required this.heatedSeats,
    required this.ventilatedSeats,
    required this.keylessEntry,
    required this.pushButtonStart,
    required this.electricParkingBrake,
    required this.memoryElectronicAdjustableSeats,
    required this.rearAcVents,
    required this.touchscreenDisplay,
    required this.bluetoothConnectivity,
    required this.appleCarplay,
    required this.androidAuto,
    required this.usbTypeCPorts,
    required this.navigationSystemGps,
    required this.voiceControl,
    required this.wirelessCharging,
    required this.premiumSoundSystem,
    required this.ledHeadlights,
    required this.fogLights,
    required this.automaticHeadlights,
    required this.rainSensingWipers,
    required this.driveModes,
  });

  factory CarFeature.fromJson(Map<String, dynamic> json) {
    bool b(String k) => json[k] == true;

    return CarFeature(
      abs: b('abs'),
      panoramicSunroof: b('panoramic_sunroof'),
      tractionControl: b('traction_control'),
      tirePressureMonitoringSystem: b('tire_pressure_monitoring_system'),
      rearParkingSensors: b('rear_parking_sensors'),
      rearviewCamera: b('rearview_camera'),
      laneDepartureWarning: b('lane_departure_warning'),
      automaticEmergencyBraking: b('automatic_emergency_braking'),
      blindSpotMonitoring: b('blind_spot_monitoring'),
      adaptiveCruiseControl: b('adaptive_cruise_control'),
      adaptiveClimateControl: b('adaptive_climate_control'),
      powerWindows: b('power_windows'),
      powerMirrors: b('power_mirrors'),
      heatedSeats: b('heated_seats'),
      ventilatedSeats: b('ventilated_seats'),
      keylessEntry: b('keyless_entry'),
      pushButtonStart: b('push_button_start'),
      electricParkingBrake: b('electric_parking_brake'),
      memoryElectronicAdjustableSeats: b('memory_electronic_adjustable_seats'),
      rearAcVents: b('rear_ac_vents'),
      touchscreenDisplay: b('touchscreen_display'),
      bluetoothConnectivity: b('bluetooth_connectivity'),
      appleCarplay: b('apple_carplay'),
      androidAuto: b('android_auto'),
      usbTypeCPorts: b('usb_type_c_ports'),
      navigationSystemGps: b('navigation_system_gps'),
      voiceControl: b('voice_control'),
      wirelessCharging: b('wireless_charging'),
      premiumSoundSystem: b('premium_sound_system'),
      ledHeadlights: b('led_headlights'),
      fogLights: b('fog_lights'),
      automaticHeadlights: b('automatic_headlights'),
      rainSensingWipers: b('rain_sensing_wipers'),
      driveModes: b('drive_modes'),
    );
  }

  // ✅ ADD THIS
  Map<String, bool> toMap() {
    return {
      'ABS': abs,
      'Panoramic Sunroof': panoramicSunroof,
      'Traction Control': tractionControl,
      'Tire Pressure Monitoring System': tirePressureMonitoringSystem,
      'Rear Parking Sensors': rearParkingSensors,
      'Rearview Camera': rearviewCamera,
      'Lane Departure Warning': laneDepartureWarning,
      'Automatic Emergency Braking': automaticEmergencyBraking,
      'Blind Spot Monitoring': blindSpotMonitoring,
      'Adaptive Cruise Control': adaptiveCruiseControl,
      'Adaptive Climate Control': adaptiveClimateControl,
      'Power Windows': powerWindows,
      'Power Mirrors': powerMirrors,
      'Heated Seats': heatedSeats,
      'Ventilated Seats': ventilatedSeats,
      'Keyless Entry': keylessEntry,
      'Push Button Start': pushButtonStart,
      'Electric Parking Brake': electricParkingBrake,
      'Memory Electronic Adjustable Seats': memoryElectronicAdjustableSeats,
      'Rear AC Vents': rearAcVents,
      'Touchscreen Display': touchscreenDisplay,
      'Bluetooth Connectivity': bluetoothConnectivity,
      'Apple CarPlay': appleCarplay,
      'Android Auto': androidAuto,
      'USB Type-C Ports': usbTypeCPorts,
      'Navigation System GPS': navigationSystemGps,
      'Voice Control': voiceControl,
      'Wireless Charging': wirelessCharging,
      'Premium Sound System': premiumSoundSystem,
      'LED Headlights': ledHeadlights,
      'Fog Lights': fogLights,
      'Automatic Headlights': automaticHeadlights,
      'Rain Sensing Wipers': rainSensingWipers,
      'Drive Modes': driveModes,
    };
  }
}
