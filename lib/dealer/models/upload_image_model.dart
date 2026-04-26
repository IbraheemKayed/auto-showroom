import 'dart:io';

class UploadingCarImage {
  final File file;
  bool isCover;
  bool isUploading;
  double progress;
  String? uploadedPath;
  bool hasError;

  UploadingCarImage({
    required this.file,
    this.isCover = false,
    this.isUploading = true,
    this.progress = 0,
    this.uploadedPath,
    this.hasError = false,
  });
}
