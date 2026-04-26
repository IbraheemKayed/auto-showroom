import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/dealer/models/upload_image_model.dart';
import 'package:sayarti/dealer/services and providers/create_car_draft.dart';

class CreateCarProvider extends ChangeNotifier {
  final CarApiService api;
  CreateCarProvider(this.api);

  // ========================
  // DRAFT
  // ========================
  final CreateCarDraft draft = CreateCarDraft();

  bool isCreating = false;
  String? error;

  // ========================
  // BASIC SETTERS
  // ========================
  String? _makeName;
  String? _modelName;

  void setMake(int id, String name) {
    draft.carMakeId = id;
    _makeName = name;
    notifyListeners();
  }

  void setModel(int id, String name) {
    draft.carModelId = id;
    _modelName = name;
    notifyListeners();
  }

  void setYear(int v) {
    draft.year = v;
    notifyListeners();
  }

  void setCategory(int id) {
    draft.categoryId = id;
    notifyListeners();
  }

  void setMileage(int v) {
    draft.mileage = v;
    notifyListeners();
  }

  void setGear(String v) {
    draft.gearType = v;
    notifyListeners();
  }

  void setFuel(int id) {
    draft.carFuelTypeId = id;
    notifyListeners();
  }

  void setInsideColor(int id) {
    draft.carInsideColorId = id;
    notifyListeners();
  }

  void setOutsideColor(int id) {
    draft.carOutsideColorId = id;
    notifyListeners();
  }

  void setDriveTrain(int id) {
    draft.carDriveTrainId = id;
    notifyListeners();
  }

  void setPrice(double v) {
    draft.price = v;
    notifyListeners();
  }

  void setEngine(String v) {
    draft.engineSize = v;
    notifyListeners();
  }

  void setPower(String v) {
    draft.power = v;
    notifyListeners();
  }

  void setPreviousOwners(int v) {
    draft.previousOwners = v;
    notifyListeners();
  }

  void setDescription(String v) {
    draft.description = v;
    notifyListeners();
  }

  void toggleFeature(String key) {
    draft.features[key] = !(draft.features[key] ?? false);
    notifyListeners();
  }

  // ========================
  // IMAGES (UPLOAD IMMEDIATELY)
  // ========================
  final List<UploadingCarImage> images = [];

  int? get mileage => draft.mileage ?? 0;
  double get price => draft.price ?? 0;
  bool get hasCover =>
      images.any((e) => e.isCover && e.uploadedPath != null);

  bool get hasMinImages =>
      images.where((e) => !e.isCover && e.uploadedPath != null).length >= 6;

  bool get isUploadingImages =>
      images.any((e) => e.isUploading);

  bool get canContinueImages =>
      hasCover && hasMinImages && !isUploadingImages;

Future<void> addImage(File file, {bool isCover = false}) async {
  if (isCover) {
    images.removeWhere((e) => e.isCover);
  }

  final img = UploadingCarImage(
    file: file,
    isCover: isCover || images.isEmpty,
  );

  images.add(img);
  notifyListeners(); 

  try {
    final path = await api.uploadSingleCarImage(
      file,
      onProgress: (sent, total) {
        img.progress = total == 0 ? 0 : sent / total;
        notifyListeners();
      },
    ); 

    img.uploadedPath = path;
    img.isUploading = false;
    img.hasError = false;
  } catch (e) {
    // ✅ لا تحذف الصورة
    img.isUploading = false;
    img.hasError = true;
    error = 'Upload failed (unauthorized)';
  }

  notifyListeners();
}




  void removeImage(UploadingCarImage img) {
    if (img.isUploading) return;
    images.remove(img);
    notifyListeners();
  }

  void setCover(UploadingCarImage img) {
    for (final i in images) {
      i.isCover = false;
    }
    img.isCover = true;
    notifyListeners();
  }

  void applyImageOrder(List<UploadingCarImage> newAdditionalOrder) {
    final cover = images.firstWhere(
      (e) => e.isCover,
      orElse: () => images.first,
    );
    images
      ..clear()
      ..add(cover)
      ..addAll(newAdditionalOrder);
    notifyListeners();
  }

  // ========================
  // VALIDATION
  // ========================
  String? validate() {
    if (draft.carModelId == null) return 'Model required';
    if (draft.year == null) return 'Year required';
    if (draft.categoryId == null) return 'Body type required';
    if (draft.mileage == null) return 'Mileage required';
    if (draft.price == null) return 'Price required';
    if (draft.engineSize == null || draft.engineSize!.isEmpty) return 'Engine size required';
    if (draft.power == null || draft.power!.isEmpty) return 'Power required';
    if (draft.description == null || draft.description!.isEmpty) return 'Description required';
    if (draft.previousOwners == null) return 'Previous owners required';

    if (!hasCover) return 'Cover image required';
    if (!hasMinImages) return 'Minimum 6 additional images required';

    return null;
  }

  // ========================
  // PUBLISH (NO IMAGE UPLOAD)
  // ========================
  Future<bool> publish() async {
    error = validate();
    if (error != null) {
      notifyListeners();
      return false;
    }

    try {
      isCreating = true;
      notifyListeners();
      await api.createCar(_buildRequest());
      isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Map<String, dynamic> _buildRequest() {
    final cover = images.firstWhere((e) => e.isCover);
    final others = images.where((e) => !e.isCover && e.uploadedPath != null);

    return {
      "gear_type": draft.gearType?.toUpperCase() ?? "AUTOMATIC",
      "mileage": draft.mileage,
      "category_id": draft.categoryId,
      "car_model_id": draft.carModelId,
      "car_fuel_type_id": draft.carFuelTypeId,
      "car_inside_color_id": draft.carInsideColorId,
      "car_outside_color_id": draft.carOutsideColorId,
      "car_drive_train_id": draft.carDriveTrainId,
      "year": draft.year,
      "price": draft.price,
      "engine_size": draft.engineSize,
      "power": draft.power,
      "description": draft.description,
      "features": draft.features,
      "previous_owners": draft.previousOwners,
      "images": [
        {
          "path": cover.uploadedPath,
          "is_cover": true,
        },
        ...others.map((e) => {
              "path": e.uploadedPath,
              "is_cover": false,
            }),
      ],
    };
  }

  // ========================
  // TITLE (UX)
  // ========================
  String get carTitle {
    if (draft.year == null) return "your car";
    return "${_makeName ?? ""} ${_modelName ?? ""} ${draft.year}".trim();
  }
}
