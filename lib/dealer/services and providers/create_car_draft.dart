import 'dart:io';

class LocalCarImage {
  final File file;
  LocalCarImage(this.file);
}

class CreateCarDraft {
  int? carModelId;
  int? carMakeId;
  int? year;
  int? categoryId;
  int? mileage;

  String? gearType;
  int? carFuelTypeId;
  int? carInsideColorId;
  int? carOutsideColorId;
  int? carDriveTrainId;

  String? engineSize;
  String? power;
  String? description;
  double? price;
  int? previousOwners;

  final Map<String, bool> features = {};

  final List<LocalCarImage> images = [];
  int coverIndex = 0;

  List<String> uploadedPaths = [];
}
